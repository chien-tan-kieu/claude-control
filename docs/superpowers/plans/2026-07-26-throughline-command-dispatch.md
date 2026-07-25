# Throughline Command Dispatch Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Extend the existing `plugin/skills/throughline/SKILL.md` so that a natural-language prompt about Throughline story/session management gets dispatched to the matching `/throughline:*` command, with mutating commands gated behind an explicit confirmation.

**Architecture:** One skill file gains frontmatter (it currently has none, so it never auto-triggers) plus a dispatch section. At trigger time the skill scans `plugin/commands/*.md` frontmatter to find the best-matching command (no hardcoded phrase table), classifies it against a small hand-maintained read-only/mutating list, confirms before executing anything mutating, and then executes by reading and following the matched command file directly — never via Skill-tool invocation of the inferred name.

**Tech Stack:** Markdown skill file (Claude Code plugin skill format), bash for command discovery, no new code/dependencies.

## Global Constraints

- Exactly one file is modified: `plugin/skills/throughline/SKILL.md`. No new files, no changes to `plugin/commands/*.md`, no new daemon endpoints.
- The existing observer notice text in `plugin/skills/throughline/SKILL.md` must be preserved, not removed or rewritten.
- The skill's frontmatter `description` must name concrete Throughline-domain vocabulary (story, handoff, standup, spec/plan linking, daemon status, dashboard, resume/session context) — this is the anchored trigger, not a broad catch-all.
- Command discovery must read `plugin/commands/*.md` at dispatch time (dynamic) — never a hardcoded "phrase → command" table baked into the skill.
- Safety classification is a hand-maintained, explicit list, exactly:
  - Read-only: `status`, `standup`, `resume`, `notes`, `open`, `story list`
  - Mutating: `story new`, `story size`, `handoff`, `plan`, `spec`, `notes-clean`
  - Any command not on either list defaults to **mutating**.
- Mutating commands require an explicit user confirmation (preview + yes) before execution; a decline or ambiguous answer means no execution and no retry with a different guess.
- Execution of a matched command always happens by reading that command's `.md` file with the Read tool and following its steps — never by invoking the command through the Skill tool using the inferred name.

---

## Task 1: Write the dispatch-enabled SKILL.md

**Files:**
- Modify: `plugin/skills/throughline/SKILL.md` (currently no frontmatter, body is just the observer notice)

**Interfaces:**
- Consumes: `plugin/commands/*.md` frontmatter `description:` fields and `Usage:` lines (read at dispatch time, not at authoring time — this task only writes the instructions that do that reading later)
- Produces: `plugin/skills/throughline/SKILL.md` with frontmatter `name: throughline`, `description: <anchored trigger>`, and a "Dispatching natural-language requests to commands" section — consumed by Task 2's validation

- [ ] **Step 1: Confirm current file contents (baseline)**

Run: `cat plugin/skills/throughline/SKILL.md`

Expected output (no frontmatter, just the observer notice):
```
# throughline

This session is being observed by the Throughline plugin.

Throughline records hook events (tool use, session start/end, subagent lifecycle) to a local SQLite database. It **never blocks tool calls or modifies responses** — it is observer-only.

No action is required from you. The daemon runs silently in the background.
```

If the contents differ from this, stop and re-read `docs/superpowers/specs/2026-07-26-throughline-command-dispatch-design.md` before proceeding — someone may have already changed this file.

- [ ] **Step 2: Write the new file content**

Replace the full contents of `plugin/skills/throughline/SKILL.md` with:

```markdown
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
```

- [ ] **Step 3: Verify frontmatter parses as valid YAML**

Run:
```bash
awk 'BEGIN{c=0} /^---$/{c++; next} c==1' plugin/skills/throughline/SKILL.md | head -5
```
Expected output:
```
name: throughline
description: Use when the user talks about Throughline stories, handoffs, standups, specs/plans linked to a story, the Throughline daemon/dashboard, or resuming session work — covers both the passive session-observation notice and dispatching natural-language requests to the matching /throughline:* command.
```
If this prints nothing, the `---` delimiters are missing or malformed — fix before continuing.

- [ ] **Step 4: Verify the observer notice text was preserved**

Run: `grep -c "never blocks tool calls or modifies responses" plugin/skills/throughline/SKILL.md`
Expected: `1`

- [ ] **Step 5: Commit**

```bash
git add plugin/skills/throughline/SKILL.md
git commit -m "$(cat <<'EOF'
feat(plugin): add natural-language command dispatch to throughline skill

Adds frontmatter (previously missing, so the skill never auto-triggered)
and a dispatch section that matches plain-language requests against
plugin/commands/*.md and executes the matching command, gated by
confirmation for mutating commands.
EOF
)"
```

---

## Task 2: Validate dispatch behavior against the scenario checklist

**Files:**
- Read only: `plugin/skills/throughline/SKILL.md` (written in Task 1)
- Possible modify: `plugin/skills/throughline/SKILL.md` (only if a scenario reveals a wording/logic gap)

**Interfaces:**
- Consumes: the full `plugin/skills/throughline/SKILL.md` content produced in Task 1
- Produces: a pass/fail record for each of the 7 scenarios from the spec's Validation section, with any fixes folded back into the same file

There is no automated test runner for skill-trigger behavior (this is prompt
content, not executable code), so each scenario is validated by dispatching
a fresh subagent that has only the skill file's content as instructions,
plus the scenario's prompt as its task — this mirrors how the real skill
would be invoked, without depending on the harness's internal relevance
matcher.

- [ ] **Step 1: Read the skill file to get its exact current content**

Run: `cat plugin/skills/throughline/SKILL.md`

Keep this output at hand — it is pasted into each subagent dispatch below as
`<SKILL_CONTENT>`.

- [ ] **Step 2: Scenario 1 — anchored trigger fires, read-only, dispatches without confirmation**

Dispatch a subagent (Agent tool, `subagent_type: general-purpose`, run in foreground) with this prompt:

```
You are simulating a Claude Code skill named "throughline". Here is its
full file content:

<SKILL_CONTENT>

A user in a session for the "throughline" repo says: "what's the status of
the daemon". Follow the skill's instructions exactly. Report: (a) which
command you matched, (b) whether you classified it read-only or mutating,
(c) whether you would ask for confirmation before running it or execute
immediately, (d) do NOT actually run any bash/curl commands — just report
your reasoning and decision.
```

Expected in the response: matched command is `status`, classified
read-only, decision is to execute immediately without asking for
confirmation.

If the response instead asks for confirmation or matches a different
command, that's a fail — note the discrepancy and fix it in Step 6.

- [ ] **Step 3: Scenario 2 — anchored trigger fires, mutating, requires confirmation**

Dispatch a subagent with:

```
You are simulating a Claude Code skill named "throughline". Here is its
full file content:

<SKILL_CONTENT>

A user in a session for the "throughline" repo says: "create a story for
adding a billing engine". Follow the skill's instructions exactly. Report:
(a) which command and subcommand you matched, (b) whether you classified it
read-only or mutating, (c) the exact preview text you would show the user,
(d) confirm you would wait for a yes before executing. Do NOT actually run
any bash/curl commands — just report your reasoning and decision.
```

Expected: matched command is `story new` (or `story`, subcommand `new`),
classified mutating, a preview naming `/throughline:story new "..."` with
an inferred title, and explicit confirmation that execution waits for a
"yes" first.

If the response executes without asking, or fails to produce a preview,
that's a fail — note it and fix in Step 6.

- [ ] **Step 4: Scenario 3 — non-trigger prompt does not activate dispatch**

This scenario tests trigger relevance, not dispatch logic, so give the
subagent only the frontmatter `description` (not the full body) plus the
prompt — this mirrors what the harness's relevance matcher sees before a
skill's body is ever loaded.

Dispatch a subagent with:

```
A Claude Code skill has this trigger description (used to decide whether
the skill is relevant enough to load for a given user message):

"Use when the user talks about Throughline stories, handoffs, standups,
specs/plans linked to a story, the Throughline daemon/dashboard, or
resuming session work — covers both the passive session-observation notice
and dispatching natural-language requests to the matching /throughline:*
command."

A user in an unrelated coding session says: "refactor the auth middleware
in packages/server to use JWT instead of session cookies". Would this
skill's description be relevant enough to load for this message? Answer
yes or no, and explain briefly.
```

Expected: the response answers "no" — nothing in the prompt touches story
management, handoffs, standups, spec/plan linking, or the daemon/dashboard.

If the response answers "yes", the description is too broad — note it and
narrow it in Step 9.

- [ ] **Step 5: Scenario 6 — no match states so plainly and suggests alternatives**

Dispatch a subagent with:

```
You are simulating a Claude Code skill named "throughline". Here is its
full file content:

<SKILL_CONTENT>

A user in a session for the "throughline" repo says: "delete all my story
files and start over from scratch". Follow the skill's instructions
exactly. Report: (a) whether any command in plugin/commands/ (story,
status, standup, handoff, resume, plan, spec, open, notes, notes-clean)
plausibly does what was asked, (b) what you would say to the user given
that. Do NOT actually run any bash/curl commands — just report your
reasoning and decision.
```

Expected: the response recognizes no existing command bulk-deletes story
files (only `notes-clean` deletes anything, and it's scoped to session
notes, not stories), states plainly that nothing fits, and names the
closest available commands (e.g. `story list`) rather than forcing a match
or executing something destructive.

If the response forces a match to an unrelated command and proceeds, that's
a fail — note it and fix in Step 9.

- [ ] **Step 6: Scenario 7 — declined confirmation results in no execution**

Dispatch a subagent with:

```
You are simulating a Claude Code skill named "throughline". Here is its
full file content:

<SKILL_CONTENT>

A user in a session for the "throughline" repo said "create a story for
adding a billing engine". You identified this as a mutating match
(/throughline:story new) and showed a preview asking for confirmation. The
user now replies: "no, don't". Follow the skill's instructions exactly.
Report what you do next. Do NOT actually run any bash/curl commands — just
report your reasoning and decision.
```

Expected: the response states it does not execute the command, does not
retry with a different guess or a different command, and simply stops
(optionally asking what the user wants instead).

If the response executes anyway, or silently substitutes a different
command, that's a fail — note it and fix in Step 9.

- [ ] **Step 7: Scenario 4 — ambiguous match asks a clarifying question**

Dispatch a subagent with:

```
You are simulating a Claude Code skill named "throughline". Here is its
full file content:

<SKILL_CONTENT>

A user in a session for the "throughline" repo says: "show me the
throughline stuff". Follow the skill's instructions exactly. Report: (a)
whether this request unambiguously matches one command from
plugin/commands/, or whether several are plausible, (b) what you would say
to the user given that. Do NOT actually run any bash/curl commands — just
report your reasoning and decision.
```

Expected: the response recognizes multiple commands are plausible (e.g.
`status`, `standup`, `story list`, `open` could all fit "stuff") and states
it would ask a clarifying question naming the candidates, rather than
picking one silently.

If the response guesses a single command without flagging the ambiguity,
that's a fail — note it and fix in Step 9.

- [ ] **Step 8: Scenario 5 — missing required argument is asked for, not fabricated**

Dispatch a subagent with:

```
You are simulating a Claude Code skill named "throughline". Here is its
full file content:

<SKILL_CONTENT>

A user in a session for the "throughline" repo says: "generate a handoff
doc" (no story ID given anywhere in the conversation so far, and there is
no way to infer one). Follow the skill's instructions exactly. Report: (a)
which command you matched, (b) whether you have enough information to fill
in its required argument(s), (c) what you would do given that. Do NOT
actually run any bash/curl commands — just report your reasoning and
decision.
```

Expected: matched command is `handoff`, the response recognizes the
required story ID argument is missing and cannot be inferred, and states it
would ask the user for the story ID rather than fabricating one or omitting
it.

If the response invents a story ID or proceeds without one, that's a fail —
note it and fix in Step 9.

- [ ] **Step 9: Reconcile results and fix any failing scenario**

For each scenario in Steps 2–8 (scenarios 1, 2, 3, 6, 7, 4, and 5), compare
the actual subagent response against its "Expected" text. If all seven
passed, write nothing further and proceed to Step 10.

If any scenario failed, identify which section of
`plugin/skills/throughline/SKILL.md` produced the wrong behavior — the
frontmatter `description` (scenario 3), discovery/matching (Step 1/2 of the
dispatch section), classification (Step 3 of the dispatch section), or
confirmation wording (Step 4 of the dispatch section) — and edit that
section to close the gap. Keep edits minimal — fix the specific ambiguity
that caused the failure, don't rewrite unrelated sections. Re-run only the
failing scenario's subagent dispatch (same prompt as before) to confirm the
fix, and repeat until it passes.

- [ ] **Step 10: Commit (only if Step 9 made changes)**

If `git status --short plugin/skills/throughline/SKILL.md` shows no
changes, skip this step — Task 1's commit already covers the validated
content.

If there are changes:
```bash
git add plugin/skills/throughline/SKILL.md
git commit -m "$(cat <<'EOF'
fix(plugin): tighten throughline dispatch wording after scenario validation
EOF
)"
```
