# Graph Report - throughline  (2026-07-27)

## Corpus Check
- 99 files · ~162,040 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 530 nodes · 869 edges · 38 communities (22 shown, 16 thin omitted)
- Extraction: 83% EXTRACTED · 17% INFERRED · 0% AMBIGUOUS · INFERRED: 145 edges (avg confidence: 0.83)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `bd78f638`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- [[_COMMUNITY_Server Lifecycle & Hook Dispatch|Server Lifecycle & Hook Dispatch]]
- [[_COMMUNITY_Command Dispatch & Observer Contract Design|Command Dispatch & Observer Contract Design]]
- [[_COMMUNITY_Web App Shell & Shared Components|Web App Shell & Shared Components]]
- [[_COMMUNITY_Project Docs & Prior Art Research|Project Docs & Prior Art Research]]
- [[_COMMUNITY_Web Dashboard Pages & Tests|Web Dashboard Pages & Tests]]
- [[_COMMUNITY_API Route Mounting|API Route Mounting]]
- [[_COMMUNITY_Superpowers Parser & Diff Engine|Superpowers Parser & Diff Engine]]
- [[_COMMUNITY_HandoffService Generation Logic|HandoffService Generation Logic]]
- [[_COMMUNITY_Daemon Lifecycle & Schema Migrations|Daemon Lifecycle & Schema Migrations]]
- [[_COMMUNITY_Shared Types & Core Services|Shared Types & Core Services]]
- [[_COMMUNITY_Story Sync & Incremental ID Design|Story Sync & Incremental ID Design]]
- [[_COMMUNITY_Start Command & Session Notes|Start Command & Session Notes]]
- [[_COMMUNITY_Kanban Board & Drag Interactions|Kanban Board & Drag Interactions]]
- [[_COMMUNITY_HandoffService Method Suite|HandoffService Method Suite]]
- [[_COMMUNITY_Version Sync & Release Scripts|Version Sync & Release Scripts]]
- [[_COMMUNITY_Changelog Extraction & Release|Changelog Extraction & Release]]
- [[_COMMUNITY_Stories Refresh & Filter Feature|Stories Refresh & Filter Feature]]
- [[_COMMUNITY_Auth & Rate Limiting|Auth & Rate Limiting]]
- [[_COMMUNITY_Changelog Script Test|Changelog Script Test]]
- [[_COMMUNITY_Security Module Tests|Security Module Tests]]
- [[_COMMUNITY_Plugin README & Status Commands|Plugin README & Status Commands]]
- [[_COMMUNITY_Plan Tables Schema|Plan Tables Schema]]
- [[_COMMUNITY_Migration Runner Tests|Migration Runner Tests]]
- [[_COMMUNITY_Handoff Service Test Suite|Handoff Service Test Suite]]
- [[_COMMUNITY_Hook Event Schemas|Hook Event Schemas]]
- [[_COMMUNITY_Community 30|Community 30]]
- [[_COMMUNITY_Community 31|Community 31]]
- [[_COMMUNITY_Community 32|Community 32]]
- [[_COMMUNITY_Community 33|Community 33]]
- [[_COMMUNITY_Community 34|Community 34]]
- [[_COMMUNITY_Community 35|Community 35]]
- [[_COMMUNITY_Community 36|Community 36]]
- [[_COMMUNITY_Community 37|Community 37]]

## God Nodes (most connected - your core abstractions)
1. `HandoffService` - 20 edges
2. `SuperpowersWatcher` - 19 edges
3. `StoryService` - 18 edges
4. `runMigrations()` - 16 edges
5. `PRD — Throughline` - 15 edges
6. `Advisor Review — Claude Control (English)` - 13 edges
7. `WsServer` - 12 edges
8. `startDaemon()` - 10 edges
9. `api client` - 10 edges
10. `Spec: Throughline Foundation (Weeks 1-2)` - 8 edges

## Surprising Connections (you probably didn't know these)
- `formatDigest` --semantically_similar_to--> `/throughline:standup command`  [INFERRED] [semantically similar]
  packages/web/src/pages/StandupPage.tsx → plugin/commands/standup.md
- `Story size enum cascade (XS-XL)` --references--> `stories table`  [INFERRED]
  docs/superpowers/specs/2026-05-17-phase3-dashboard-design.md → packages/server/migrations/002_superpowers.sql
- `Story: incremental integer story IDs` --references--> `stories table`  [INFERRED]
  docs/superpowers/stories/US-2026-06-08-optimize-story-id-generation-to-use-incr.md → packages/server/migrations/002_superpowers.sql
- `/throughline:standup command` --conceptually_related_to--> `api client`  [INFERRED]
  plugin/commands/standup.md → packages/web/src/lib/api.ts
- `mountStandupRoutes` --implements--> `StandupService (design)`  [INFERRED]
  packages/server/src/api/standup.ts → docs/superpowers/specs/2026-05-17-phase3-dashboard-design.md

## Hyperedges (group relationships)
- **DocsPage: story → design spec → rendered screenshots, styled per shared design system** — spec_plan_viewer_docs_page_plan, story_story_detail_screenshot, active_story_docs_viewer_screenshot, design_supabase_design_system [INFERRED 0.85]
- **Advisor review's recommendations shaping the handoff feature and product framing** — advisor_review_en, auto_handoff_cross_session_memory_plan, readme_readme [INFERRED 0.80]
- **Board screenshot as visual evidence of completed feature stories** — board_stories_board_screenshot, story_id_incremental_plan, filter_stories_by_status_plan, versioning_and_release_plan [INFERRED 0.85]
- **Release mechanism evolution (versioning -> dist build -> manual dispatch)** — spec_versioning_release, spec_plugin_distribution_build, spec_manual_release_workflow [INFERRED 0.85]
- **Hook ingestion pipeline (forward -> validate -> persist -> observer {})** — foundation_forward_sh, foundation_hookeventschema, foundation_persistevent, foundation_observer_contract, foundation_security_gate [INFERRED 0.85]
- **Implementation-notes enforcement mechanism (Stop hook + strikes + per-session pointer)** — notes_check_sh, notes_block_to_continue, notes_two_strike_cap, notes_per_session_pointer [INFERRED 0.85]
- **Versioning and release mechanism** — us_2026_06_01_implement_versioning_and_release_mechani, sync_version_test_syncversion, extract_changelog_test_extractchangelog, index_startdaemon [INFERRED 0.85]
- **Handoff generation and schema evolution** — 003_handoffs_handoffs, 005_handoff_session_handoffs, phase3_dashboard_design_handoffservice, index_startdaemon [INFERRED 0.75]
- **Story identity and persistence** — 002_superpowers_stories, 004_story_seq_seq, stories_mountstoryroutes, us_2026_06_08_optimize_story_id_generation_to_use_incr [INFERRED 0.75]
- **API route dispatch** — index_mountapiroutes, handoff_mounthandoffroutes, sessions_mountsessionroutes [INFERRED 0.85]
- **Session handoff generation pipeline** — index_handoffservice_generateforsession, index_handoffservice_minesession, index_handoffservice_buildstorysections, index_handoffservice_writehandoff [INFERRED 0.85]
- **Hook event persistence flow** — handlers_dispatchevent, index_persistevent, index_upsertsession, index_endsession [INFERRED 0.85]
- **Plan change parse-diff-advance flow** — index_superpowerswatcher, plan_parseplan, diff_diffcheckboxstate, phase_advancephase [INFERRED 0.85]
- **Story markdown-to-DB persistence pipeline** — index_storyservice, story_parsefrontmatter, template_scaffoldstory, index_applypatch [INFERRED 0.85]
- **WebSocket broadcast payload types** — index_wsserver, api_wsout, api_eventrecord, plan_plantask [INFERRED 0.75]
- **App shell layout composition** — app_shell, topbar_topbar, sidebar_sidebar [INFERRED 0.75]
- **Story kanban filter feature** — ui_useuistore, filterbar_filterbar, kanbancolumn_kanbancolumn, storiespage_storiespage [INFERRED 0.75]
- **WebSocket live connection status flow** — usewebsocket_usewebsocket, ws_usewsstore, topbar_topbar [INFERRED 0.75]
- **WebSocket-driven React Query cache invalidation** — usewebsocket_usewebsocket, storiespage_storiespage, storypage_storypage, docspage_docspage, api_api [INFERRED 0.85]
- **Active story id shared via ws store** — ws_usewsstore, usewebsocket_usewebsocket, storycard_storycard, docspage_docspage [INFERRED 0.85]
- **Standup digest rendering pipeline** — standuppage_standuppage, statsgrid_statsgrid, standupsection_standupsection [INFERRED 0.85]
- **Story status routes to backlog/in-progress/done modes** — start_command, backlog_mode, in_progress_mode, done_mode, story_mode_dispatch [EXTRACTED 0.90]
- **Release orchestration: bump, sync, changelog** — release_main, release_bumpversion, sync_version_syncversion, release_buildchangelogentry [EXTRACTED 0.90]
- **Commands share daemon bootstrap + runtime.json auth** — ensure_daemon_bootstrap, runtime_json, start_command, story_command, handoff_command [INFERRED 0.85]

## Communities (38 total, 16 thin omitted)

### Community 0 - "Server Lifecycle & Hook Dispatch"
Cohesion: 0.08
Nodes (15): dispatchEvent(), handleHookEvent(), registerShutdownHandler(), startIdleTimer(), writeRuntimeJson(), createBus(), startDaemon(), createServer() (+7 more)

### Community 1 - "Command Dispatch & Observer Contract Design"
Cohesion: 0.06
Nodes (53): /throughline:resume command, start.md command (status-branching dispatch), Anchored trigger description (first line of defense), Dynamic command discovery from frontmatter (no static table), Read-only vs mutating tiers + confirmation gate, plugin/skills/throughline/SKILL.md (command dispatch router), bootstrap.sh (daemon probe + spawn), checkAuth (bearer token + Host validation) (+45 more)

### Community 2 - "Web App Shell & Shared Components"
Cohesion: 0.06
Nodes (11): useWebSocket(), apiFetch(), base(), formatDigest(), handleCopy(), HierarchyStrip(), SizePill(), StatusPill() (+3 more)

### Community 3 - "Project Docs & Prior Art Research"
Cohesion: 0.09
Nodes (37): Throughline Dashboard — Docs/Spec viewer screenshot, Advisor Review — Claude Control (English), Advisor Review — Claude Control (Vietnamese), Plan: Auto-handoff / Cross-session Memory, Jesse Vincent — "Superpowers: How I'm using coding agents" (blog.fsck.com), Throughline Dashboard — All Stories board screenshot, Throughline Project Guide (root CLAUDE.md), ColeMurray/claude-code-otel (+29 more)

### Community 4 - "Web Dashboard Pages & Tests"
Cohesion: 0.09
Nodes (39): api client, apiFetch helper, App, Shell, DocsPage, DocsPage test suite, FilterBar, FilterBar test suite (+31 more)

### Community 5 - "API Route Mounting"
Cohesion: 0.11
Nodes (13): mountHandoffRoutes(), relativeAge(), mountApiRoutes(), mountSessionRoutes(), mountStandupRoutes(), mountStoryRoutes(), parseFrontmatter(), StandupService (+5 more)

### Community 6 - "Superpowers Parser & Diff Engine"
Cohesion: 0.09
Nodes (8): mountSuperpowersRoutes(), validatePath(), parsePlan(), diffCheckboxState(), SuperpowersWatcher, parseSpec(), advancePhase(), inferPhase()

### Community 7 - "HandoffService Generation Logic"
Cohesion: 0.09
Nodes (30): dispatchEvent, Handlers handoff tests, SKILL_PHASE_MAP, mountHandoffRoutes, relativeAge, ApiCtx, endSession, handleHookEvent (+22 more)

### Community 8 - "Daemon Lifecycle & Schema Migrations"
Cohesion: 0.08
Nodes (28): sessions table, stories table, handoffs table (initial), stories.seq column, handoffs table rebuild (session_id), BusEvent union, createBus, startDaemon daemon test (+20 more)

### Community 9 - "Shared Types & Core Services"
Cohesion: 0.11
Nodes (24): EventRecord, Phase, Session, WSOut, CheckboxDiff, diffCheckboxState, applyPatch, isValidStoryId (+16 more)

### Community 10 - "Story Sync & Incremental ID Design"
Cohesion: 0.13
Nodes (23): Plan: Real-Time Story Sync, Spec: Real-Time Story Sync, Spec: Spec/Plan Viewer (DocsPage), Spec: Incremental Story IDs (US{n}), Spec: Superpowers Integration + Stories (Phase 2), Incremental story IDs US{n} (seq column + MAX(seq)+1), Migration 004_story_seq.sql (seq column + partial unique index), diffCheckboxState (plan checkbox diff) (+15 more)

### Community 11 - "Start Command & Session Notes"
Cohesion: 0.14
Nodes (22): Active story (sessions/current), Start mode: Backlog (brainstorming), superpowers:brainstorming skill, DocsPage.tsx dashboard component, Start mode: Done (closure review), Daemon bootstrap (ensure-daemon.sh), /throughline:handoff command, Implementation notes artifacts (pointer, notes file, nudge counter) (+14 more)

### Community 14 - "Version Sync & Release Scripts"
Cohesion: 0.33
Nodes (4): buildChangelogEntry(), bumpVersion(), main(), syncVersion()

### Community 15 - "Changelog Extraction & Release"
Cohesion: 0.29
Nodes (8): CHANGELOG.md, extractChangelog(), buildChangelogEntry(), bumpVersion(), release.mjs main(), root package.json (authoritative version), makeFixture() test helper, syncVersion()

### Community 16 - "Stories Refresh & Filter Feature"
Cohesion: 0.54
Nodes (8): Plan: Stories Refresh Button & Last-Updated Time, Spec: Filter Stories by Status, Spec: Stories Refresh Button & Last-Updated Time, FilterBar (status pills + refresh control), KanbanColumn (isFiltered fade + empty state), Refresh button + last-updated timestamp (dataUpdatedAt), StoriesPage (kanban board, useQuery stories), useUiStore (Zustand UI store, storyFilter)

### Community 19 - "Security Module Tests"
Cohesion: 1.0
Nodes (3): checkAuth, RateLimiter, Security tests

### Community 20 - "Plugin README & Status Commands"
Cohesion: 0.67
Nodes (3): /throughline:open command, Throughline plugin README, /throughline:status command

## Knowledge Gaps
- **84 isolated node(s):** `Advisor Review — Claude Control (Vietnamese)`, `Per-Session Implementation Notes Implementation Plan`, `Workflow Visualizer (Surface A)`, `Story sizing (S/M/L)`, `Scrum-vs-Kanban product framing critique` (+79 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **16 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `SuperpowersWatcher` connect `Superpowers Parser & Diff Engine` to `Server Lifecycle & Hook Dispatch`, `API Route Mounting`?**
  _High betweenness centrality (0.016) - this node is a cross-community bridge._
- **Why does `StoryService` connect `API Route Mounting` to `Server Lifecycle & Hook Dispatch`?**
  _High betweenness centrality (0.015) - this node is a cross-community bridge._
- **Why does `HandoffService` connect `HandoffService Method Suite` to `Server Lifecycle & Hook Dispatch`, `API Route Mounting`?**
  _High betweenness centrality (0.014) - this node is a cross-community bridge._
- **Are the 3 inferred relationships involving `PRD — Throughline` (e.g. with `Incremental Story IDs (US{n}) Implementation Plan` and `Phase 2: Superpowers Integration + Stories Implementation Plan`) actually correct?**
  _`PRD — Throughline` has 3 INFERRED edges - model-reasoned connections that need verification._
- **What connects `Advisor Review — Claude Control (Vietnamese)`, `Per-Session Implementation Notes Implementation Plan`, `Workflow Visualizer (Surface A)` to the rest of the system?**
  _84 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Server Lifecycle & Hook Dispatch` be split into smaller, more focused modules?**
  _Cohesion score 0.08 - nodes in this community are weakly interconnected._
- **Should `Command Dispatch & Observer Contract Design` be split into smaller, more focused modules?**
  _Cohesion score 0.06 - nodes in this community are weakly interconnected._