#!/bin/sh
# Installs git hooks that call scripts/graphify-safe-update.sh in the
# background after every commit and branch switch, keeping the graphify
# knowledge graph current for code changes at no API cost.
#
# Run once per machine/clone: .git/hooks/ is never tracked by git, so a fresh
# clone of this repo has no hooks until this script runs. (graphify-out/'s
# existence and the graphify CLI itself are separate prerequisites — see the
# graphify section in CLAUDE.md.)
set -e

PROJECT_ROOT=$(git rev-parse --show-toplevel)
HOOKS_DIR="$PROJECT_ROOT/.git/hooks"
mkdir -p "$HOOKS_DIR"

cat > "$HOOKS_DIR/post-commit" <<'EOF'
#!/bin/sh
GIT_DIR=$(git rev-parse --git-dir 2>/dev/null)
[ -d "$GIT_DIR/rebase-merge" ] && exit 0
[ -d "$GIT_DIR/rebase-apply" ] && exit 0
[ -f "$GIT_DIR/MERGE_HEAD" ] && exit 0
[ -f "$GIT_DIR/CHERRY_PICK_HEAD" ] && exit 0
PROJECT_ROOT=$(git rev-parse --show-toplevel)
_LOG="${HOME}/.cache/graphify-rebuild.log"
mkdir -p "$(dirname "$_LOG")"
nohup "$PROJECT_ROOT/scripts/graphify-safe-update.sh" > "$_LOG" 2>&1 < /dev/null &
disown 2>/dev/null || true
EOF
chmod +x "$HOOKS_DIR/post-commit"

cat > "$HOOKS_DIR/post-checkout" <<'EOF'
#!/bin/sh
BRANCH_SWITCH=$3
[ "$BRANCH_SWITCH" != "1" ] && exit 0
GIT_DIR=$(git rev-parse --git-dir 2>/dev/null)
[ -d "$GIT_DIR/rebase-merge" ] && exit 0
[ -d "$GIT_DIR/rebase-apply" ] && exit 0
[ -f "$GIT_DIR/MERGE_HEAD" ] && exit 0
[ -f "$GIT_DIR/CHERRY_PICK_HEAD" ] && exit 0
PROJECT_ROOT=$(git rev-parse --show-toplevel)
_LOG="${HOME}/.cache/graphify-rebuild.log"
mkdir -p "$(dirname "$_LOG")"
nohup "$PROJECT_ROOT/scripts/graphify-safe-update.sh" > "$_LOG" 2>&1 < /dev/null &
disown 2>/dev/null || true
EOF
chmod +x "$HOOKS_DIR/post-checkout"

echo "graphify git hooks installed: post-commit, post-checkout -> scripts/graphify-safe-update.sh"
