---
name: game-playtest-squad
description: Run evidence-based multi-agent or multi-profile playtests for browser, desktop, or mobile games across genres such as action, platformer, shooter, RPG, adventure, puzzle, card/deckbuilder, strategy, sim/management, racing, rhythm, narrative, and multiplayer games. Use when Codex is asked to test a game with several agents/players, simulate beginner-to-mid skill levels, validate first-run behavior, investigate loading/image/audio/input/performance/network issues, compare playtest tiers such as 3-player quick, 5-player standard, or 5-player slow-network, gather feedback, then iterate fixes and retest.
---

# Game Playtest Squad

## Purpose

Use this skill to coordinate repeatable, genre-agnostic game playtests that feel like several fresh players trying the game for the first time. The goal is to catch basic blockers before human testing: blank screens, missing art, bad loading, audio interruptions, input issues, unreadable UI, broken rules or progression flows, crashes, and first-run confusion.

This skill exists for AI-assisted game development, where many games can be generated quickly but human player attention is scarce. Use AI playtests as an early quality gate that removes obvious blockers and produces actionable fix packets before asking real players to spend time on the game.

Only spawn subagents when the user explicitly asks for agents, multiple testers, a test squad, or parallel playtesting. Otherwise, run the same profiles locally yourself with browser automation or the repo's existing test tools.

## Project Language

Keep public project material English-first because this skill is intended to become open source. Use concise Traditional Chinese as secondary context when it helps the project owner or local collaborators, but do not make Chinese the only explanation for core usage, reports, scripts, or contribution guidance.

## Start Here

Before testing, identify the target surface and make the run reproducible.

1. Find the playable target: local URL, preview URL, build artifact, desktop app, or mobile/emulator path.
2. Run the environment preflight and resolve missing test tooling when it is safe to do so.
3. Identify the game type, core loop, win/fail conditions, input modes, save/persistence model, and whether online or multiplayer behavior matters.
4. If the target is a repo, inspect existing scripts and start the normal dev or preview server instead of inventing a new run path.
5. Choose the smallest useful tier and state the profile matrix before running.
6. Capture console errors, page errors, failed requests, failed responses, and timing markers from the start of page load.
7. Use screenshots, video, state snapshots, logs, or pixel checks for visual claims such as blank canvas, missing art, clipped HUD, unreadable overlays, or wrong gameplay state.

## Environment Preflight

Before running a playtest, check whether the current machine has the tools needed for the target. Do this in the background when possible and report only useful results.

- For URL-only browser tests, check for an available browser automation path: Playwright, an installed Chromium/Chrome/Edge browser, screenshots, console logging, network capture, and fresh browser contexts.
- For repo-based browser games, inspect package files and scripts first, then check the matching runtime and package manager: Node.js, npm, pnpm, yarn, bun, Python, pip, uv, or other project-declared tools.
- For desktop or engine builds, check only the tools required to launch the provided build. Do not assume Unity, Godot, Unreal, Steam, itch, Android Studio, Xcode, or emulators are installed unless the target requires them.
- For video, audio, or media evidence, check for ffmpeg or the browser's built-in recording support when needed.
- Prefer project-local dependencies and documented setup commands over global installs. If the repo has `package.json`, lockfiles, setup scripts, or README instructions, use those as the source of truth.
- If a common test dependency is missing and the environment allows installation, install the smallest reasonable tool needed to run the test, then state what was installed. Examples: project `npm install`, Playwright browser download, Python packages used by the repo's own test scripts.
- Do not silently install large engines, SDKs, emulators, paid/proprietary tools, drivers, or tools requiring login. Ask first or report the test as blocked with the exact missing requirement.
- If installation fails, continue with the best available lower-fidelity test when useful, and label the limitation clearly.
- Do not treat missing tooling as a game bug. Separate environment blockers from product findings in the Human Report and AI Fix Packet.

## URL-Only Playtests

Support "drop a link and test it" workflows. If the user provides only a playable URL, preview URL, localhost URL, itch.io page, Netlify/Vercel preview, or similar browser-openable target, open it and run the appropriate playtest tier without requiring repo access first.

- Treat the URL as the target app and use fresh browser contexts for each profile.
- Capture page load timing, console errors, page errors, failed requests, failed HTTP responses, broken images, screenshots, and visible gameplay state.
- Infer the game type and core loop from the page and playable flow. Label the inference if no project docs or source code are available.
- If the page is a storefront or landing page before the playable game, find and open the actual playable frame, launch button, embedded canvas, or downloadable build when possible.
- If login, payment, age gate, invite-only access, browser permissions, anti-bot checks, or missing credentials block testing, report the blocker clearly instead of pretending the game was tested.
- When source code is unavailable, keep the AI Fix Packet focused on observable symptoms, console/network evidence, URLs, screenshots, and likely areas such as loading, audio, input, or asset delivery. Do not invent file paths or root causes.

## Multilingual UI

Many games use Chinese, Japanese, Korean, or mixed-language UI. Do not assume important buttons are labeled in English.

- Treat non-English UI as normal, not as an edge case. The test should still try to start the game, choose options, and play the first loop.
- Use Unicode-safe automation. Avoid shell or script patterns that corrupt non-ASCII labels into `??`. If the shell is not reliably UTF-8, use DOM structure, element positions, accessible roles, screenshots, or Unicode code-point matching instead of inline non-ASCII regex literals.
- Prefer visible-state and flow-aware selectors over English-only text matching. For example, identify the main menu's first large action button, save-slot cards, character cards, map cards, confirm buttons, and back buttons by visibility, layout, and screen state.
- When using text, collect actual visible labels from the page and compare them safely. Include the observed labels in the raw evidence when they guide clicks.
- If language selection exists, record the default language and whether switching language affects the flow. Do not switch language unless it is part of the profile or needed to proceed.
- If the tester fails to proceed because it cannot understand or select non-English UI, classify that as a test automation limitation first, then improve the selector strategy before reporting a game bug.

## Game Type Discovery

Before choosing scenarios, classify the game by what the player actually does. If the repo or product text is unclear, infer from the playable build and label the inference.

- Core loop: move/fight/collect, jump/explore, solve, build/manage, race, perform rhythm inputs, choose cards, make turns, read/dialogue, trade/craft, compete/cooperate online.
- Player goal: survive, clear a level, solve a puzzle, win a match, finish a lap/song, complete a quest, grow resources, unlock content, or reach a story branch.
- Failure and recovery: death, timeout, wrong answer, lost match, bankrupt state, desync, softlock, restart, retry, undo, checkpoint, save/load.
- Primary input: touch, keyboard/mouse, controller, drag/drop, text entry, timing taps, aiming, camera look, menus only, or mixed controls.
- Risk focus: loading/assets, controls, rules, economy, progression, AI/opponent behavior, camera, collision, latency, persistence, accessibility/readability, or performance.

## Genre Lenses

Pick only the lenses that match the game. Do not force every genre check into every run.

- Action, survivor, shooter, brawler: movement, aiming, hit feedback, enemy contact, projectiles, damage, pickups, ability cooldowns, boss/special waves, death/revive, enemy density, frame pacing.
- Platformer, metroidvania: jump feel, collision, ledges, hazards, camera, checkpoints, respawn, doors/transitions, progression gates, controller and keyboard mapping.
- RPG, adventure, narrative: dialogue flow, quest objective clarity, inventory/equipment, map transitions, save/load, cutscenes, branching choices, progression locks, readable text.
- Puzzle, word, trivia: rule clarity, valid/invalid moves, hints, undo/retry, scoring, level completion, failure state, random seed reproducibility, no softlocks.
- Card, deckbuilder, board, turn-based strategy: turn order, card/rule text, legal move enforcement, AI/opponent turns, resource costs, draw/discard, status effects, win/loss resolution.
- Sim, management, crafting, idle: resource production/spending, build/place/edit flows, timers, offline or accelerated progress, economy balance smoke, dense UI scanning, persistence.
- Racing, sports, rhythm: input latency, timing windows, scoring, camera/track readability, collision/out-of-bounds, restart, lap/song/match completion, replay or result screens.
- Multiplayer or online: lobby, matchmaking, invite/join, reconnect, latency handling, authoritative state, desync, disconnect recovery, chat/privacy settings, result settlement. If real multiplayer cannot be run locally, state that clearly and test only the available approximation.

## Test Tiers

Choose the smallest tier that fits the request.

- `3-player quick`: use after small fixes. Run one phone portrait beginner, one phone portrait second-character or alternate-build player, and one desktop keyboard beginner.
- `5-player standard`: use before important bugfix pushes or release candidates. Add one tablet/larger-phone player and one focused player for late-game, boss, level, victory, or special ability flow.
- `5-player slow-network`: use for loading bars, image/audio failures, Netlify/preview slowness, mobile first-screen blankness, or first-run asset bugs. Use the same five profiles, but throttle or delay network for at least two phone profiles and one focused boss/ability profile.

Avoid more than 8 browser-running agents unless the user accepts that local CPU, RAM, GPU, and network contention can distort timing.

Use these default device targets unless the game or user request implies better values:

- Phone portrait: `390x844` or a named modern phone profile with touch enabled.
- Phone alternate profile: same size family, fresh context, different character/build/vehicle/deck/puzzle path/mode.
- Desktop keyboard: `1366x768` or larger, keyboard and mouse controls enabled.
- Tablet/larger-phone: `820x1180` portrait; add landscape only when the game claims landscape support.
- Focused systems profile: the viewport and controls most likely to expose the changed or risky system.

## Fresh Player Rules

Every tester must behave like a first-time player.

- Use a fresh browser context/profile for each tester.
- Disable cache where possible.
- Clear or isolate `localStorage`, `sessionStorage`, IndexedDB, CacheStorage, cookies, and service workers.
- Do not reuse played save slots unless the test is specifically about persistence.
- Record whether the game shows tutorials, onboarding, loading screens, save creation, character selection, map/level selection, and first input prompts correctly.

## Player Profiles

Adapt names to the game being tested, but keep the roles distinct.

- Phone beginner: cautious player, taps obvious buttons, checks first screen, tutorial, movement, first enemy/contact, first reward.
- Phone alternate-mechanic player: picks a different character, weapon, class, deck, vehicle, puzzle path, dialogue branch, or mode; checks variant-specific art, rules, ability, and controls.
- Desktop keyboard player: checks keyboard/mouse flow, canvas/window scaling, default controls, readable HUD, and basic progression.
- Tablet/larger-phone player: checks responsive layout, touch target spacing, overlays, modals, and portrait/landscape if relevant.
- Focused systems player: checks the highest-risk system in the current change, such as boss spawn, special attack, level completion, puzzle completion, turn resolution, economy loop, map transition, inventory, shop, save/load, online reconnect, victory/defeat, or audio.

For beginner-to-mid skill simulation, do not optimize perfectly. Let agents make ordinary choices, move imperfectly, pause to read, and report confusing UI or unclear feedback.

When the user explicitly asks for multi-agent playtesting, assign one profile per agent. Give each agent the target URL/app, tier, viewport, network mode, read-only or edit permission, and the required report fields. If fixes are delegated, keep each agent's write scope separate and tell them not to revert other edits.

## What To Measure

For loading and asset issues, record:

- First visible paint or time to nonblank game canvas.
- Boot/menu loading duration.
- Run/level loading duration.
- Time until playable input is accepted.
- Failed requests, HTTP status errors, and `requestfailed` reasons.
- Broken DOM images and game images with zero width/height.
- Whether required character/player, map/background, enemies, pickups, projectiles, bosses, special ability art, UI icons, and result screens appear.
- Audio request failures, aborted media, stutter, repeated restart, autoplay blocks, and whether user gesture is required.

For gameplay issues, record:

- Whether the first complete core loop can be performed: one fight, one jump section, one puzzle, one turn, one card play, one build action, one lap, one rhythm phrase, one dialogue choice, or the closest equivalent.
- Input responsiveness and whether controls match the displayed hints.
- Whether the first combat loop is understandable.
- Whether rewards/level-up/shop/upgrade flows can be completed.
- Whether special abilities show their visual/audio feedback promptly.
- Whether boss or late-game checks are real-time or accelerated.
- Frame pacing when possible: FPS, p95 frame time, long frames, and viewport/device profile.
- Whether genre-specific result states work: level clear, solved puzzle, failed puzzle, match win/loss, quest update, race finish, song results, crafted item, saved game, or reconnect outcome.

## Network Simulation

Use browser automation or DevTools/CDP throttling when useful.

- Disable cache.
- Add realistic latency, for example `150-250ms` round trip for a normal mobile simulation.
- Cap download/upload throughput, for example about `1.5Mbps` down and `750Kbps` up for a moderate slow-mobile pass.
- Optionally add route delays for images/audio to expose race conditions.
- Label artificial slow-network results clearly; they are reproducible approximations, not perfect substitutes for real phones on production hosting.

Use real-time flow for startup, loading, audio, first input, first special ability, and player feel. Use accelerated test-mode jumps only for targeted checks such as boss identity, final-level ceremony, or victory flow, and label them as accelerated.

## Iteration Loop

Use this loop for each playtest round:

1. Run the selected tier with fresh profiles.
2. Summarize findings by severity and recurrence.
3. Separate product bugs from test artifacts such as overloaded local machine, headless-browser audio limits, or intentionally harsh throttling.
4. Fix high-severity and repeated issues first.
5. Rerun the smallest tier that covers the fixes.
6. Stop when basic blockers are gone: no blank first screen, no broken required art, no blocking load, no crash, no stuck main flow, no missing required special/boss/result visuals.

Leave subjective balance, taste, or long-session feel for human play unless the user asks agents to continue tuning.

## Cleanup

After collecting data:

- Close every Playwright page, context, browser, emulator, or external browser automation session.
- Stop temporary local servers.
- Close finished subagents that are no longer needed.
- Keep screenshots/logs that are referenced as evidence, but organize them under the artifact layout below instead of leaving loose files in the output root.
- Confirm the next playtest round starts from fresh profiles, not old cache or saved state.

## Artifact Layout

Keep playtest outputs easy for a human to open. Use one folder per tested game/build, then put the readable report at the second level and raw evidence at the third level.

Use this layout:

```text
test-artifacts/
  <game-slug>-<target-or-build>-<YYYY-MM-DD>/
    report.md
    evidence/
      raw/
      screenshots/
      traces/
      videos/
      attempts/
```

- `report.md` is the human entry point. A project owner should be able to open this file first and understand the result without browsing raw logs.
- Put raw JSON, console logs, network logs, traces, screenshots, videos, and exploratory failed attempts under `evidence/`, never loose beside other game folders.
- If multiple rounds are run for the same game on the same day, keep them in the same game folder and separate raw data under `evidence/round-1`, `evidence/round-2`, or similarly clear names.
- Keep evidence paths linked from `report.md` when they support a finding.
- Ignore or exclude artifact folders from source-control commits unless the user explicitly asks to publish test evidence.

## Reporting

Report concise evidence, not just vibes.

- Start with setup: tier, profiles, device/viewports, network settings, target URL/app, and whether tests were real-time or accelerated.
- List blocking issues first with reproduction steps and likely cause.
- Include key timing numbers and failed/missing asset URLs when relevant.
- Say what was fixed and what was retested.
- Note remaining risks that still need real-device or production-preview testing.

Always separate output for two audiences unless the user asks for a different shape.

### Human Report

Write this for a non-specialist project owner, not for a professional game designer. Many AI-era game creators are using vibe coding and may not know design, QA, engine, or performance terminology. Use plain language first, explain why each issue matters to a player, and translate technical evidence into practical impact.

- Verdict: use plain labels such as "Ready for a small human test", "Not ready yet", "Playable but risky", or "Blocked", then include pass/fail/partial/blocked if useful.
- One-sentence summary: say what a normal player would experience, for example "The game opens and can be played, but the first fight slows down badly on desktop."
- What was tested: describe the game type, core loop, tier, profiles, devices, network mode, and target URL/app without assuming the reader knows QA terms.
- Main findings: blocking issues first, then repeated non-blocking issues, then polish concerns. For each issue, state the player-visible symptom before technical detail.
- Evidence: screenshots/video/log/report paths, key timing numbers, FPS/p95, failed requests, missing assets, or concrete state snapshots. Explain technical numbers in plain terms, such as "low FPS means the game looked choppy."
- Fix/retest status: what was fixed, what was rerun, and whether the issue reproduced again.
- Next step: state the next practical action in plain language, such as "fix loading before asking players", "test on a real phone", or "ready for a friend to try for 10 minutes."
- Remaining risk: real-device, production-hosting, multiplayer, long-session, save migration, or subjective feel that still needs human testing.

Avoid unexplained terms like p95, repro, regression, softlock, desync, cache, render, tick, or asset pipeline in the human report. If a term is useful, define it briefly in the same sentence.

### AI Fix Packet

When there is any bug, regression, or follow-up fix, include a structured packet that another agent can act on without re-reading the whole report.

Use one packet per issue:

```text
Issue ID:
Severity: blocker | high | medium | low
Status: open | fixed | retest-needed | blocked
Game type / lens:
Profile and viewport:
Target URL/app/build:
Network mode:
Real-time or accelerated:
Reproduction steps:
Expected behavior:
Actual behavior:
Evidence:
Console/page errors:
Failed requests:
Likely area to inspect:
Suggested first fix:
Retest command or scenario:
```

Keep the AI packet factual. Do not invent file paths, root causes, or commands; use "unknown" when the test evidence does not identify them yet.
