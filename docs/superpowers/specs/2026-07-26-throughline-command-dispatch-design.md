# Throughline command dispatch (skill-based router)

## Problem

Throughline's plugin capabilities are exposed as explicit slash commands under
`plugin/commands/*.md` (e.g. `/throughline:story`, `/throughline:status`,
`/throughline:handoff`). These only run when a user types the exact command
name. There's no way to trigger them from a natural-language prompt (e.g.
"what's the story status?" or "create a story for the billing engine") — the
user has to already know the command exists and its exact name.

Skills, unlike commands, can auto-trigger based on relevance matching against
their frontmatter `description`. This project wants a skill that, when a
prompt is clearly about Throughline story/session management, infers which
underlying command applies and executes it — without requiring the user to
type the slash form.

## Goals

- Let natural-language prompts reach existing Throughline commands without
  the user needing to know or type exact command names.
- Keep the explicit slash commands working exactly as they do today — this is
  an additional entry point, not a replacement.
- Avoid duplicating each command's logic; the router should stay a thin
  dispatch layer over the existing command files.
- Minimize the risk of unintended or misfired actions, especially for
  commands that mutate state (create/write/delete).

## Non-goals

- Rewriting or restructuring the existing command files themselves.
- Adding new daemon endpoints or API behavior.
- Building a generic "skill router" for non-Throughline commands.

## Design

### Placement

The dispatch logic is added to the **existing** `plugin/skills/throughline/SKILL.md`
— no new skill directory. That file currently contains only a short
observer notice ("this session is being observed, no action required"). The
notice stays; dispatch logic is added below it in the same file, under the
same trigger.

### Trigger

The skill's frontmatter `description` is an **anchored trigger**: it must
name concrete Throughline-domain vocabulary (story, handoff, standup,
spec/plan linking, daemon status, dashboard, resume/session context) rather
than a broad "user wants to manage project work" description. This keeps the
skill from activating on unrelated conversation — activation is the first
line of defense against misfires, before any command-matching logic runs.

### Discovery (intent → command mapping)

Rather than hardcoding a static "phrase → command" table inside the skill
(which would drift out of sync as commands are added or their usage
changes), the skill discovers commands dynamically at dispatch time:

1. List `plugin/commands/*.md` and extract each file's frontmatter
   `description:` (and `Usage:` line where present) via a simple text scan —
   no parsing library needed.
2. Match the user's request against that live set of descriptions to select
   the best-fitting command (and subcommand, e.g. `story new` vs `story
   list` vs `story size`).
3. Infer required arguments (e.g. a story title or ID) from the prompt or
   surrounding context, using each command's stated `Usage:` line as the
   contract for what's required.

Because the mapping is derived from the command files themselves, adding,
editing, or removing a command file automatically changes what the router
can reach — there is no second copy of "what commands exist" to maintain.

**Dispatch mechanism**: matched commands are executed by reading the target
`.md` file with the Read tool and following its instructions directly — the
same steps that would run if the user had typed the slash form. The skill
does **not** invoke commands via the Skill tool using the inferred command
name, since command invocation through that interface is reserved for
prompts where the user explicitly typed the slash form; auto-triggered
skills reaching commands that way would be relying on undefined behavior.

### Safety classification and confirmation gate

The skill body carries a small, explicit, hardcoded list separating
commands into two tiers. This classification is deliberate and manually
maintained — never inferred at runtime:

- **Read-only** (dispatched immediately, no confirmation):
  `status`, `standup`, `resume`, `notes`, `open`, `story list`
- **Mutating** (confirmation required before executing):
  `story new`, `story size`, `handoff`, `plan`, `spec`, `notes-clean`

For a mutating match, before reading/executing the command file the skill
presents a one-line preview of the inferred command and what it will do, and
waits for explicit approval, e.g.:

> "This looks like `/throughline:story new \"Add billing engine\"` — creates
> a new story via the daemon and writes its file. Run it?"

Only an explicit yes proceeds to execute the command file's steps. A no or
unclear response ends the dispatch with no side effects — the skill does not
retry with a guessed variant or silently downgrade to a different action.

**Unclassified commands default to the mutating tier.** If a new command
file is added and not yet added to the read-only list, the skill treats it
as confirm-first until someone deliberately reclassifies it. New commands
are never auto-treated as safe.

### Ambiguity and error handling

- **No plausible match**: the skill states plainly that nothing in
  `plugin/commands/*.md` fits well, and suggests the closest explicit slash
  command(s) instead of guessing or doing nothing silently.
- **Ambiguous match** (multiple commands plausibly fit): the skill asks a
  short clarifying question naming the candidates rather than picking one.
- **Missing required argument** (e.g. no story ID inferable for `handoff`):
  the skill asks for the missing piece rather than fabricating one.
- **Daemon/runtime errors**: unchanged. Each command file already has its
  own bootstrap step (`ensure-daemon.sh`, reading `.throughline/runtime.json`)
  and error handling. The router does not duplicate or override this — it
  simply hands off to the matched command file's existing steps once a match
  (and any required confirmation) is resolved.

## Validation

This is a prompt-based skill; there is no automated test runner for
skill-trigger behavior. Readiness is checked against a scenario checklist,
each walked through manually against the finished `SKILL.md`:

1. **Anchored trigger fires (read-only)** — "what's the status of the
   daemon" → dispatches `status` immediately, no confirmation.
2. **Anchored trigger fires (mutating)** — "create a story for adding a
   billing engine" → shows preview of `story new "..."`, waits for yes.
3. **Non-trigger prompt stays silent** — an unrelated coding request does
   not activate the skill at all.
4. **Ambiguous match** — a vague prompt matching two commands → skill asks a
   clarifying question instead of guessing.
5. **Missing required arg** — "generate a handoff" with no story ID
   inferable from context → skill asks for the ID rather than fabricating
   one.
6. **No match** — skill states it found nothing well-suited and points at
   the closest explicit command(s).
7. **Confirmation declined** — user says no to a mutating preview → nothing
   executes.

## Risks and mitigations

| Risk | Mitigation |
|---|---|
| Skill misfires on unrelated prompts | Anchored trigger description (domain-specific vocabulary required to activate at all) |
| Mutating action runs from a misread intent | Preview + explicit confirmation required for every mutating command before execution |
| Mapping drifts from actual commands over time | Dynamic discovery from command file frontmatter at dispatch time, not a hardcoded table |
| New command silently treated as safe to auto-run | Unclassified commands default to the confirm-first tier |
| Router duplicates/diverges from command logic | Router always defers to reading and following the actual command file; never reimplements command steps |
