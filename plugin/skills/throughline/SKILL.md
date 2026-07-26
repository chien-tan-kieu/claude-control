---
name: throughline
description: Use when the user talks about Throughline stories, handoffs, standups, specs/plans linked to a story, the Throughline daemon/dashboard, or resuming session work — covers both the passive session-observation notice and dispatching natural-language requests to the matching /throughline:* command.
---

# throughline

This session is being observed by the Throughline plugin.

Throughline records hook events (tool use, session start/end, subagent lifecycle) to a local SQLite database. It **never blocks tool calls or modifies responses** — it is observer-only.

No action is required from you for the observation itself. The daemon runs silently in the background.

## Dispatching natural-language requests to commands

Throughline's commands (`plugin/commands/*.md`) only run when a user types
the exact slash form (e.g. `/throughline:story new "..."`). This section
covers what to do when the user instead describes what they want in plain
language, and their request matches Throughline domain vocabulary.

### Step 1: Discover available commands

List and read the frontmatter of every command file — run this from the
repo root every time you dispatch:

```bash
for f in plugin/commands/*.md; do
  echo "=== $(basename "$f" .md) ==="
  awk '/^description:/{sub(/^description: /,""); print}' "$f"
done
```

Never hardcode a static list of commands and trigger phrases here. The
match must always be against the current contents of `plugin/commands/*.md`,
so a new or edited command is picked up automatically without editing this
skill.

### Step 2: Match intent to a command

Compare the user's request to the descriptions gathered in Step 1 (and each
command's `Usage:` line, visible in the file body) to pick the best-fitting
command and subcommand — e.g. "what's going on with the daemon" → `status`;
"create a story for the billing engine" → `story` with subcommand `new`.

Infer required arguments (story title, story ID, file path) from the user's
prompt or the surrounding conversation. If a required argument can't be
inferred, ask the user for it — do not fabricate one.

If more than one command plausibly fits, or nothing fits well, do not guess:
- **Ambiguous** — ask a short clarifying question naming the candidate
  commands.
- **No match** — say plainly that nothing in `plugin/commands/*.md` fits,
  and name the closest explicit command(s) the user could type instead.

### Step 3: Classify the match as read-only or mutating

This list is maintained by hand and reviewed whenever a command file is
added or removed — it is never inferred from the command's content:

- **Read-only** (dispatch immediately, no confirmation needed):
  `status`, `standup`, `resume`, `notes`, `open`, `story list`
- **Mutating** (confirmation required before executing):
  `story new`, `story size`, `handoff`, `plan`, `spec`, `notes-clean`

Any command not on either list — including any newly added command file —
is treated as **mutating** until this list is deliberately updated. Never
default a new or unrecognized command to read-only.

### Step 4: Confirm (mutating only), then execute

For a **read-only** match, proceed straight to execution (below).

For a **mutating** match, present a one-line preview of the inferred
command and what it does, and wait for explicit approval before doing
anything else, e.g.:

> This looks like `/throughline:story new "Add billing engine"` — creates a
> new story via the daemon and writes its file. Run it?

- If the user confirms, proceed to execution.
- If the user declines or answers ambiguously, stop. Do not execute, retry
  with a different guess, or fall back to a different command.

**Execution**: read the matched command's `.md` file (e.g.
`plugin/commands/story.md`) with the Read tool and follow its documented
steps exactly, as if the user had typed the slash command themselves,
including that command's own daemon bootstrap and error handling. Do not
invoke the command via the Skill tool using the inferred name — that path
is reserved for prompts where the user typed the slash form explicitly.
