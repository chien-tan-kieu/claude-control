# Graph Report - throughline  (2026-07-25)

## Corpus Check
- 99 files · ~156,900 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 551 nodes · 755 edges · 67 communities (36 shown, 31 thin omitted)
- Extraction: 85% EXTRACTED · 15% INFERRED · 0% AMBIGUOUS · INFERRED: 113 edges (avg confidence: 0.83)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `eb7d3412`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- [[_COMMUNITY_Foundation Design & Hook Contracts|Foundation Design & Hook Contracts]]
- [[_COMMUNITY_HandoffService Generation Logic|HandoffService Generation Logic]]
- [[_COMMUNITY_API Route Mounting|API Route Mounting]]
- [[_COMMUNITY_Daemon Lifecycle & Startup|Daemon Lifecycle & Startup]]
- [[_COMMUNITY_Cross-Cutting ServerWeb Wiring|Cross-Cutting Server/Web Wiring]]
- [[_COMMUNITY_Research Corpus & Prior Art|Research Corpus & Prior Art]]
- [[_COMMUNITY_Web Dashboard Components|Web Dashboard Components]]
- [[_COMMUNITY_Start Command & Slash Commands|Start Command & Slash Commands]]
- [[_COMMUNITY_Superpowers Watcher & Plan Diffing|Superpowers Watcher & Plan Diffing]]
- [[_COMMUNITY_Shared Types & Zod Schemas|Shared Types & Zod Schemas]]
- [[_COMMUNITY_Web App Shell & WebSocket Hook|Web App Shell & WebSocket Hook]]
- [[_COMMUNITY_Hook Event Handling & Session Store|Hook Event Handling & Session Store]]
- [[_COMMUNITY_Docs Page Design Spec|Docs Page Design Spec]]
- [[_COMMUNITY_Dashboard Kanban Design Spec|Dashboard Kanban Design Spec]]
- [[_COMMUNITY_Release & Version Sync Scripts|Release & Version Sync Scripts]]
- [[_COMMUNITY_Story Detail View Design|Story Detail View Design]]
- [[_COMMUNITY_WebSocket Server (WsServer)|WebSocket Server (WsServer)]]
- [[_COMMUNITY_Migration & Service Test Suite|Migration & Service Test Suite]]
- [[_COMMUNITY_Incremental Story ID Design|Incremental Story ID Design]]
- [[_COMMUNITY_Design System Tokens|Design System Tokens]]
- [[_COMMUNITY_Sidebar & WebSocket Store Tests|Sidebar & WebSocket Store Tests]]
- [[_COMMUNITY_Story Filter Store Tests|Story Filter Store Tests]]
- [[_COMMUNITY_Stories Refresh & Filter Feature|Stories Refresh & Filter Feature]]
- [[_COMMUNITY_Process Lifecycle Helpers|Process Lifecycle Helpers]]
- [[_COMMUNITY_Changelog Extraction Script|Changelog Extraction Script]]
- [[_COMMUNITY_Auth Rate Limiting|Auth Rate Limiting]]
- [[_COMMUNITY_Superpowers API Route|Superpowers API Route]]
- [[_COMMUNITY_Standup API Route|Standup API Route]]
- [[_COMMUNITY_WebSocket Connection Store|WebSocket Connection Store]]
- [[_COMMUNITY_UI Filter Store|UI Filter Store]]
- [[_COMMUNITY_Changelog Script Test|Changelog Script Test]]
- [[_COMMUNITY_Incremental Story ID Plan|Incremental Story ID Plan]]
- [[_COMMUNITY_TDD & Verification Rules|TDD & Verification Rules]]
- [[_COMMUNITY_Bun Toolchain & Release Process|Bun Toolchain & Release Process]]
- [[_COMMUNITY_StatsGrid Node|StatsGrid Node]]
- [[_COMMUNITY_TypeIcon Component|TypeIcon Component]]
- [[_COMMUNITY_HierarchyStrip Component|HierarchyStrip Component]]
- [[_COMMUNITY_StatusPill Component|StatusPill Component]]
- [[_COMMUNITY_StepRow Node|StepRow Node]]
- [[_COMMUNITY_LinkedCard Node|LinkedCard Node]]
- [[_COMMUNITY_Topbar Test|Topbar Test]]
- [[_COMMUNITY_Security Module Index|Security Module Index]]
- [[_COMMUNITY_Runtime JSON Interface|Runtime JSON Interface]]
- [[_COMMUNITY_Story Template Scaffolding|Story Template Scaffolding]]
- [[_COMMUNITY_Hook Round-Trip Integration Test|Hook Round-Trip Integration Test]]
- [[_COMMUNITY_Phase Inference Test|Phase Inference Test]]
- [[_COMMUNITY_WebSocket Server Test|WebSocket Server Test]]
- [[_COMMUNITY_Shared Types Barrel|Shared Types Barrel]]
- [[_COMMUNITY_Spec Viewer Design Contract Skill|Spec Viewer Design Contract Skill]]
- [[_COMMUNITY_Real-Time Story Sync Plan|Real-Time Story Sync Plan]]
- [[_COMMUNITY_Stories Status Filter Story|Stories Status Filter Story]]
- [[_COMMUNITY_Story Routes Mounting|Story Routes Mounting]]
- [[_COMMUNITY_Spec Parsing Function|Spec Parsing Function]]
- [[_COMMUNITY_Implementation Notes Rule|Implementation Notes Rule]]
- [[_COMMUNITY_No Unrequested Commits Rule|No Unrequested Commits Rule]]

## God Nodes (most connected - your core abstractions)
1. `HandoffService` - 20 edges
2. `SuperpowersWatcher` - 19 edges
3. `StoryService` - 18 edges
4. `runMigrations()` - 16 edges
5. `Advisor Review — Claude Control (EN)` - 15 edges
6. `WsServer` - 12 edges
7. `Superpowers Integration + Stories Design (Phase 2)` - 11 edges
8. `startDaemon()` - 10 edges
9. `ensure-daemon.sh bootstrap` - 9 edges
10. `/throughline:start command` - 8 edges

## Surprising Connections (you probably didn't know these)
- `Observer-only guarantee` --conceptually_related_to--> `dispatchEvent`  [INFERRED]
  README.md → packages/server/src/hooks/handlers.ts
- `docs/superpowers is historical, not a backlog` --conceptually_related_to--> `SuperpowersWatcher`  [INFERRED]
  plugin/constitution.md → packages/server/src/superpowers/index.ts
- `Story: Optimize Story ID generation to use incremental integers` --references--> `Migration 004: Story seq column for incremental IDs`  [INFERRED]
  docs/superpowers/stories/US-2026-06-08-optimize-story-id-generation-to-use-incr.md → packages/server/migrations/004_story_seq.sql
- `Superpowers lifecycle (brainstorm to implement)` --conceptually_related_to--> `SKILL_PHASE_MAP`  [INFERRED]
  README.md → packages/server/src/hooks/handlers.ts
- `Superpowers lifecycle (brainstorm to implement)` --conceptually_related_to--> `advancePhase`  [INFERRED]
  README.md → packages/server/src/superpowers/phase.ts

## Hyperedges (group relationships)
- **Version propagation across the monorepo** — release_bumpversion, sync_version_syncversion, index_version [INFERRED 0.85]
- **Services sharing the stories table** — index_storyservice, index_standupservice, index_handoffservice [INFERRED 0.85]
- **Kanban board render pipeline** — storiespage_storiespage, kanbancolumn_kanbancolumn, storycard_storycard [EXTRACTED 1.00]
- **Lifecycle phase inference** — handlers_dispatchevent, phase_inferphase, phase_advancephase, index_superpowerswatcher [INFERRED 0.85]
- **Cross-session handoff generation** — handlers_dispatchevent, handoff_mounthandoffroutes, index_endsession [INFERRED 0.75]
- **Event bus publish/subscribe fan-out** — handlers_dispatchevent, index_superpowerswatcher, index_wsserver [INFERRED 0.85]
- **Story status dispatches to mode file** — start_command, backlog_mode, in_progress_mode, done_mode [EXTRACTED 1.00]
- **Command daemon bootstrap flow** — prd_ensure_daemon, prd_runtime_json, prd_daemon, prd_bearer_auth [INFERRED 0.85]
- **Kanban context utilities** — prd_user_story, prd_standup_digest, prd_handoff_notes, prd_kanban_layer [EXTRACTED 1.00]
- **Plan-change pipeline: watcher parses, diffs, infers phase** — 2026_05_13_superpowers_integration_stories_design_superpowerswatcher, 2026_05_13_superpowers_integration_stories_design_parseplan, 2026_05_13_superpowers_integration_stories_design_diffcheckbox, 2026_05_13_superpowers_integration_stories_design_inferphase [EXTRACTED 1.00]
- **Release mechanism evolution: release-it -> release.mjs/dist branch -> manual workflow_dispatch** — 2026_06_02_versioning_release_design_releaseit, 2026_06_02_versioning_release_design_syncversion, 2026_07_14_plugin_distribution_build_design_releasescript, 2026_07_14_plugin_distribution_build_design_distbranch, 2026_07_17_manual_release_workflow_design_workflowdispatch [INFERRED 0.85]
- **Cross-session memory: session mining, latest endpoint, resume/start surfaces** — 2026_06_22_auto_handoff_cross_session_memory_design_generateforsession, 2026_06_22_auto_handoff_cross_session_memory_design_latestendpoint, 2026_06_07_start_command_status_branching_design_modefiles [INFERRED 0.85]
- **Scrum-to-Kanban gap: work-item axis present, iteration axis absent** — advisor_kanban_sdd_companion, advisor_phase_status_orthogonal, advisor_martin_fowler_sdd [INFERRED 0.85]
- **Coupling fragility risks of the observer layer** — advisor_phase_inference, advisor_superpowers_coupling, advisor_obra_superpowers [INFERRED 0.85]
- **Version consistency across runtime, status endpoint, and semver source** — us_20260601_semver, us_20260601_runtime_json, us_20260601_status_endpoint_version [INFERRED 0.75]

## Communities (67 total, 31 thin omitted)

### Community 0 - "Foundation Design & Hook Contracts"
Cohesion: 0.05
Nodes (62): Bun daemon (port-binding singleton), Throughline Foundation Design (Weeks 1-2), HookEventSchema (Zod discriminated union of 14 hook events), Observer contract (every handler returns exactly {}), persistEvent + session lifecycle store, Security gate (Bearer token + Host check + rate limit), Throughline Foundation Implementation Plan, diffCheckboxState (plan step change detection) (+54 more)

### Community 1 - "HandoffService Generation Logic"
Cohesion: 0.09
Nodes (10): HandoffService, dispatchEvent(), handleHookEvent(), checkAuth(), RateLimiter, endSession(), persistEvent(), upsertSession() (+2 more)

### Community 2 - "API Route Mounting"
Cohesion: 0.1
Nodes (15): mountHandoffRoutes(), relativeAge(), mountApiRoutes(), mountSessionRoutes(), mountStandupRoutes(), mountStoryRoutes(), mountSuperpowersRoutes(), validatePath() (+7 more)

### Community 3 - "Daemon Lifecycle & Startup"
Cohesion: 0.11
Nodes (8): registerShutdownHandler(), startIdleTimer(), writeRuntimeJson(), createBus(), startDaemon(), createServer(), StandupService, runMigrations()

### Community 4 - "Cross-Cutting Server/Web Wiring"
Cohesion: 0.07
Nodes (34): handoffs table (session_id migration), api client object, apiFetch, BusEvent union, createBus, DocsPage, HandoffService, StandupService (+26 more)

### Community 5 - "Research Corpus & Prior Art"
Cohesion: 0.08
Nodes (33): Advisor Review — Claude Control (EN), Advisor Review — Claude Control (VI), ColeMurray/claude-code-otel, Cross-session memory / handoff (flagship use case), disler/claude-code-hooks-multi-agent-observability, GitHub spec-kit, hoangsonww/Claude-Code-Agent-Monitor, Jesse Vincent — Superpowers blog post (+25 more)

### Community 6 - "Web Dashboard Components"
Cohesion: 0.08
Nodes (9): apiFetch(), base(), formatDigest(), handleCopy(), HierarchyStrip(), SizePill(), StatusPill(), TypeIcon() (+1 more)

### Community 7 - "Start Command & Slash Commands"
Cohesion: 0.13
Nodes (29): Start Mode: Backlog, Start Mode: Done, /throughline:handoff command, Start Mode: In Progress, /throughline:open command, /throughline:plan command, Bearer token + Host validation, Superpowers brainstorming skill (+21 more)

### Community 8 - "Superpowers Watcher & Plan Diffing"
Cohesion: 0.11
Nodes (5): parsePlan(), diffCheckboxState(), SuperpowersWatcher, advancePhase(), inferPhase()

### Community 9 - "Shared Types & Zod Schemas"
Cohesion: 0.12
Nodes (21): HookEventSchema — zod discriminated union, parseFrontmatter() function, parsePlan() function, ParsedPlan / PlanTask / PlanStep types, Phase — brainstorm | spec | plan | implement, server/superpowers/__tests__/parser.test.ts, server/superpowers/__tests__/watcher.test.ts, shared/api.ts — Phase, Session, WSOut, StandupDigest (+13 more)

### Community 10 - "Web App Shell & WebSocket Hook"
Cohesion: 0.15
Nodes (3): useWebSocket(), Shell(), MockWebSocket

### Community 11 - "Hook Event Handling & Session Store"
Cohesion: 0.15
Nodes (17): docs/superpowers is historical, not a backlog, diffCheckboxState, dispatchEvent, SKILL_PHASE_MAP, mountHandoffRoutes, relativeAge, endSession, handleHookEvent (+9 more)

### Community 12 - "Docs Page Design Spec"
Cohesion: 0.19
Nodes (14): Active Story Card, Architecture File Change Tables, Story/Docs Completion Checklist, Dark Theme UI Design, Throughline Dashboard, DocsPage Combined Spec+Plan View, Docs Panel with Spec/Plan Tabs, Parent Story & Documents Side Panel (+6 more)

### Community 13 - "Dashboard Kanban Design Spec"
Cohesion: 0.2
Nodes (12): Dark Theme UI, Throughline Dashboard, All Stories Kanban Board, Workflow Phase Stepper (Brainstorm / Spec / Plan / Implement), Session ID & Live Status Indicator, Sidebar Navigation (Active Story / Workspace / Reports), Standup Report Link, Status Columns (Backlog / In Progress / Done) (+4 more)

### Community 14 - "Release & Version Sync Scripts"
Cohesion: 0.33
Nodes (4): buildChangelogEntry(), bumpVersion(), main(), syncVersion()

### Community 15 - "Story Detail View Design"
Cohesion: 0.25
Nodes (11): Acceptance Criteria Checklist, Dark Theme UI, Story Detail View, Linked Documents Panel, Properties Panel (Status/Size), Sidebar Navigation, Spec/Plan Viewer Design Docs, Done Status Badge (+3 more)

### Community 18 - "Migration & Service Test Suite"
Cohesion: 0.25
Nodes (5): store/migrate.ts, runMigrations(), standup/service.test.ts, store/store.test.ts, stories/service.test.ts

### Community 19 - "Incremental Story ID Design"
Cohesion: 0.32
Nodes (8): isValidStoryId() — dual-format story ID validator, US{n} incremental story ID format, Migration 003: Handoffs table, Migration 001: Initial schema (sessions, events), Migration 004: Story seq column for incremental IDs, Migration 002: Superpowers (stories, plan_tasks, plan_steps), Design: Incremental Story IDs (US{n}), Story: Optimize Story ID generation to use incremental integers

### Community 20 - "Design System Tokens"
Cohesion: 0.38
Nodes (7): Border-Defined Depth System, Color Palette & Roles, Component Stylings, HSL-Based Color Token System, Layout Principles, Supabase-Inspired Design System, Typography Rules

### Community 21 - "Sidebar & WebSocket Store Tests"
Cohesion: 0.47
Nodes (6): DocsPage.test, Sidebar, Sidebar.test, useWebSocket, useWebSocket.test, useWsStore

### Community 22 - "Story Filter Store Tests"
Cohesion: 0.5
Nodes (5): FilterBar, FilterBar.test, StoriesPage.test, useUiStore, ui-store.test

### Community 23 - "Stories Refresh & Filter Feature"
Cohesion: 0.4
Nodes (5): Plan — Filter Stories by Status, Spec — Filter Stories by Status Design, Spec — Stories Refresh Button Design, FilterBar Component — Story Status Filter Pills, Stories Board Refresh Button + Last Updated Time

### Community 27 - "Superpowers API Route"
Cohesion: 0.67
Nodes (3): api/superpowers.ts, mountSuperpowersRoutes(), validatePath() (private)

### Community 28 - "Standup API Route"
Cohesion: 0.67
Nodes (3): API Router (mountApiRoutes), API: Standup routes, ApiCtx — shared service context passed to route handlers

## Ambiguous Edges - Review These
- `frontend-design skill (shared styling system)` → `Phase inference via hardcoded skill names (brittle)`  [AMBIGUOUS]
  docs/reviews/advisor-review-2026-06-19.en.md · relation: conceptually_related_to

## Knowledge Gaps
- **116 isolated node(s):** `Script: extract-changelog`, `web/tailwind.config.js`, `web/postcss.config.js`, `web/test-setup.ts — vitest setup`, `StatsGrid` (+111 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **31 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **What is the exact relationship between `frontend-design skill (shared styling system)` and `Phase inference via hardcoded skill names (brittle)`?**
  _Edge tagged AMBIGUOUS (relation: conceptually_related_to) - confidence is low._
- **Why does `SuperpowersWatcher` connect `Superpowers Watcher & Plan Diffing` to `HandoffService Generation Logic`, `API Route Mounting`, `Daemon Lifecycle & Startup`?**
  _High betweenness centrality (0.016) - this node is a cross-community bridge._
- **Why does `StoryService` connect `API Route Mounting` to `Daemon Lifecycle & Startup`?**
  _High betweenness centrality (0.015) - this node is a cross-community bridge._
- **Why does `HandoffService` connect `HandoffService Generation Logic` to `API Route Mounting`, `Daemon Lifecycle & Startup`?**
  _High betweenness centrality (0.014) - this node is a cross-community bridge._
- **What connects `Script: extract-changelog`, `web/tailwind.config.js`, `web/postcss.config.js` to the rest of the system?**
  _116 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Foundation Design & Hook Contracts` be split into smaller, more focused modules?**
  _Cohesion score 0.05 - nodes in this community are weakly interconnected._
- **Should `HandoffService Generation Logic` be split into smaller, more focused modules?**
  _Cohesion score 0.09 - nodes in this community are weakly interconnected._