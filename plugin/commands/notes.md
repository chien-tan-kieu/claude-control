---
description: Display the current session's implementation notes (decisions, deviations, trade-offs)
allowed-tools:
  - Bash
  - Read
---

Load and display the implementation notes file for the current session (see `plugin/constitution.md` rule 7 and `plugin/hooks/notes-check.sh`). Purely local — no daemon needed.

**Step 1: Resolve project root and session id**

```bash
PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
echo "PROJECT_ROOT=$PROJECT_ROOT"
echo "SESSION_ID=${CLAUDE_CODE_SESSION_ID:-}"
```

If `SESSION_ID` is empty, fall back to the most recently modified pointer file:
```bash
ls -t "$PROJECT_ROOT/.throughline/notes/"*.pointer 2>/dev/null | head -1
```
Use its basename with `.pointer` stripped as `SESSION_ID`. If no pointer files exist either, print "No implementation notes found." and stop.

**Step 2: Read the pointer**

```bash
cat "$PROJECT_ROOT/.throughline/notes/${SESSION_ID}.pointer" 2>/dev/null
```

If this file doesn't exist or is empty, print "No implementation notes for this session yet." and stop.

**Step 3: Read the notes file**

Use the Read tool on `$PROJECT_ROOT/.throughline/notes/<pointer contents>`. If it doesn't exist, print "Notes file `<pointer contents>` is registered but missing on disk." and stop.

**Step 4: Get last-modified time**

```bash
stat -f "%Sm" -t "%Y-%m-%d %H:%M" "$PROJECT_ROOT/.throughline/notes/<filename>" 2>/dev/null || stat -c "%y" "$PROJECT_ROOT/.throughline/notes/<filename>" 2>/dev/null | cut -d. -f1
```

**Step 5: Display**

Print the notes to the chat as formatted markdown, using the file's own top-level `# <title>` heading if present (otherwise the filename) and its own `##` section headings verbatim — do not summarize or rewrite the content, just present it cleanly:

```
## 📓 <title>

*Session `<first 8 chars of SESSION_ID>` · updated <last-modified time> · `.throughline/notes/<filename>`*

---

<full content of the notes file, verbatim, minus its own top-level title since it's shown above>
```
