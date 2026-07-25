---
description: Delete the current session's implementation notes file, pointer, and nudge counter
allowed-tools:
  - Bash
---

Clean up the implementation notes artifacts for the current session. Usage: `/throughline:notes-clean [--force]`

Purely local file deletion — no daemon needed. These files are gitignored (`.throughline/` is excluded via `git/info/exclude`), so deletion here is **not** recoverable from git history.

**Step 1: Resolve project root and session id**

```bash
PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
echo "SESSION_ID=${CLAUDE_CODE_SESSION_ID:-}"
```

If `SESSION_ID` is empty, fall back to the most recently modified pointer file (same as `/throughline:notes` step 1). If none exist, print "No implementation notes artifacts found." and stop.

**Step 2: Resolve target files**

- Pointer: `$PROJECT_ROOT/.throughline/notes/${SESSION_ID}.pointer`
- Notes file: whatever filename the pointer contains, under `.throughline/notes/`
- Nudge counter: `$PROJECT_ROOT/.throughline/notes-nudge/${SESSION_ID}.count`

Check existence of each with `[ -f ... ]`. If none exist, print "No implementation notes artifacts for this session." and stop.

**Step 3: Show what will be removed**

List only the files that actually exist, with size for the notes file:
```
Will remove:
- .throughline/notes/<filename> (<size>)
- .throughline/notes/<session_id>.pointer
- .throughline/notes-nudge/<session_id>.count   (if present)
```

**Step 4: Confirm**

If ARGUMENTS does not contain `--force`, ask the user to confirm deletion before proceeding (mention it's unrecoverable since the directory is gitignored). If they decline, stop without deleting anything.

**Step 5: Delete**

```bash
rm -f "$PROJECT_ROOT/.throughline/notes/<filename>" \
      "$PROJECT_ROOT/.throughline/notes/${SESSION_ID}.pointer" \
      "$PROJECT_ROOT/.throughline/notes-nudge/${SESSION_ID}.count"
```

**Step 6: Confirm result**

Print: `Removed implementation notes for session <first 8 chars of SESSION_ID>.`
