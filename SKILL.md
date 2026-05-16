---
name: game-playtest-squad
description: Run multi-agent or multi-profile first-run playtests for browser, desktop, or mobile games. Use when Codex is asked to test a game with several agents/players, simulate beginner-to-mid skill levels, validate first-time-player behavior, investigate loading/image/audio/mobile issues, compare playtest tiers such as 3-player quick, 5-player standard, or 5-player slow-network, gather feedback, then iterate fixes and retest.
---

# Game Playtest Squad

## Purpose

Use this skill to coordinate repeatable game playtests that feel like several fresh players trying the game for the first time. The goal is to catch basic blockers before human testing: blank screens, missing art, bad loading, audio interruptions, input issues, unreadable UI, broken boss/level flows, crashes, and first-run confusion.

Only spawn subagents when the user explicitly asks for agents, multiple testers, a test squad, or parallel playtesting. Otherwise, run the same profiles locally yourself with browser automation or the repo's existing test tools.

## Start Here

Before testing, identify the target surface and make the run reproducible.

1. Find the playable target: local URL, preview URL, build artifact, desktop app, or mobile/emulator path.
2. If the target is a repo, inspect existing scripts and start the normal dev or preview server instead of inventing a new run path.
3. Choose the smallest useful tier and state the profile matrix before running.
4. Capture console errors, page errors, failed requests, failed responses, and timing markers from the start of page load.
5. Use screenshots or pixel checks for visual claims such as blank canvas, missing art, clipped HUD, or unreadable overlays.

## Test Tiers

Choose the smallest tier that fits the request.

- `3-player quick`: use after small fixes. Run one phone portrait beginner, one phone portrait second-character or alternate-build player, and one desktop keyboard beginner.
- `5-player standard`: use before important bugfix pushes or release candidates. Add one tablet/larger-phone player and one focused player for late-game, boss, level, victory, or special ability flow.
- `5-player slow-network`: use for loading bars, image/audio failures, Netlify/preview slowness, mobile first-screen blankness, or first-run asset bugs. Use the same five profiles, but throttle or delay network for at least two phone profiles and one focused boss/ability profile.

Avoid more than 8 browser-running agents unless the user accepts that local CPU, RAM, GPU, and network contention can distort timing.

Use these default device targets unless the game or user request implies better values:

- Phone portrait: `390x844` or a named modern phone profile with touch enabled.
- Phone alternate profile: same size family, fresh context, different character/build/mode.
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
- Phone alternate-character/build player: picks a different character, weapon, class, deck, or mode; checks character-specific art, ability, and controls.
- Desktop keyboard player: checks keyboard/mouse flow, canvas/window scaling, default controls, readable HUD, and basic progression.
- Tablet/larger-phone player: checks responsive layout, touch target spacing, overlays, modals, and portrait/landscape if relevant.
- Focused systems player: checks the highest-risk system in the current change, such as boss spawn, ultimate/special attack, victory/defeat, map transition, inventory, shop, save/load, or audio.

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

- Input responsiveness and whether controls match the displayed hints.
- Whether the first combat loop is understandable.
- Whether rewards/level-up/shop/upgrade flows can be completed.
- Whether special abilities show their visual/audio feedback promptly.
- Whether boss or late-game checks are real-time or accelerated.
- Frame pacing when possible: FPS, p95 frame time, long frames, and viewport/device profile.

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
- Keep screenshots/logs that are referenced as evidence; delete or ignore temporary artifacts that are not referenced.
- Confirm the next playtest round starts from fresh profiles, not old cache or saved state.

## Reporting

Report concise evidence, not just vibes.

- Start with setup: tier, profiles, device/viewports, network settings, target URL/app, and whether tests were real-time or accelerated.
- List blocking issues first with reproduction steps and likely cause.
- Include key timing numbers and failed/missing asset URLs when relevant.
- Say what was fixed and what was retested.
- Note remaining risks that still need real-device or production-preview testing.
