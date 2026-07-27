#!/bin/sh
# Wrapper around graphify's AST-only rebuild that skips it entirely (no file
# writes, no built_at_commit stamp) when no code file has changed since the
# last run. Without this, every commit rewrites built_at_commit unconditionally
# even when only docs/config changed, producing a diff that chases itself on
# the next commit.
#
# Called by .git/hooks/post-commit and .git/hooks/post-checkout (installed by
# scripts/setup-graphify-hooks.sh — git hooks aren't tracked by git, so that
# must be re-run after a fresh clone) and by the PostToolUse hook in
# .claude/settings.json.
set -e

PROJECT_ROOT="${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
cd "$PROJECT_ROOT" || exit 0

[ -d graphify-out ] || exit 0
command -v graphify >/dev/null 2>&1 || exit 0

LOCK="graphify-out/.graphify-safe-update.lock"
mkdir "$LOCK" 2>/dev/null || exit 0
trap 'rmdir "$LOCK" 2>/dev/null || true' EXIT

# Resolve the graphify python interpreter the same way the graphify skill does
# (handles uv tool / pipx / venv / system installs).
GRAPHIFY_PYTHON=""
if [ -f graphify-out/.graphify_python ]; then
    GRAPHIFY_PYTHON=$(cat graphify-out/.graphify_python)
    "$GRAPHIFY_PYTHON" -c "import graphify" 2>/dev/null || GRAPHIFY_PYTHON=""
fi
if [ -z "$GRAPHIFY_PYTHON" ]; then
    GRAPHIFY_BIN=$(command -v graphify)
    _SHEBANG=$(head -1 "$GRAPHIFY_BIN" | tr -d '#!')
    case "$_SHEBANG" in
        *[!a-zA-Z0-9/_.-]*) GRAPHIFY_PYTHON="python3" ;;
        *)
            if "$_SHEBANG" -c "import graphify" 2>/dev/null; then
                GRAPHIFY_PYTHON="$_SHEBANG"
            else
                GRAPHIFY_PYTHON="python3"
            fi
            ;;
    esac
fi

"$GRAPHIFY_PYTHON" -c "
import sys
from pathlib import Path
from graphify.detect import detect_incremental, CODE_EXTENSIONS

incremental = detect_incremental(Path('.'))
new_code = len(incremental.get('new_files', {}).get('code', []))
deleted_code = [
    f for f in incremental.get('deleted_files', [])
    if Path(f).suffix.lower() in CODE_EXTENSIONS
]

if incremental.get('incremental') and new_code == 0 and not deleted_code:
    print('[graphify-safe-update] No code changes since last rebuild - skipping.')
    sys.exit(0)

from graphify.watch import _rebuild_code
ok = _rebuild_code(Path('.'))
sys.exit(0 if ok else 1)
"
