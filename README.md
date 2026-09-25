# SerenityHubv2 — collaboration library

Readable development copy of Serenity's existing library. Production is unchanged.
Source tree snapshot: f45cc48c0f12645f3302dc99ac621ca8545b3163 (2026-09-25).

## Public loader — unchanged
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/MUshihara/Serenity-hub/main/loader.lua"))()
```
This repository's root loader forwards to that release. It does NOT run unfinished v2 games.

## Test the new-game example
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/MUshihara/SerenityHubv2/main/games/example.lua"))()
```
This opens a harmless development UI example. It has no game automation or presence reporting.
Run only in an appropriate test session; the shared UI can replace a previous UI instance.

## Contents
- dist/: readable UI bundles and shared core, retaining dependency paths.
- src/: local translation dictionaries and runtime.
- scripts/: translation build/audit checks.
- games/: one readable example; add one file per new game.
- docs/: collaboration, localization and presence documentation.
- services/: reference presence Worker source and tests; no deployment is configured.

No obfuscated game payloads, access-key files, game release wrappers, experiments, or duplicate source repository history are copied.
Legacy UI dependencies are retained because the shared entry point still exposes compatibility routes.
Static artwork remains at its existing pinned asset URL; it is not duplicated.

## Important differences from production
Internal library fetches resolve to SerenityHubv2. Layout and gameplay-independent UI behavior are otherwise retained.
Embedded production feedback webhook credentials were removed: feedback requires a deliberately configured destination before use.
The example uses the universal adapter directly to avoid recording development executions in production stats.
The shared dist/ui/serenity-v3.lua entry still contains the existing presence/Discord behavior; read docs before using it in a test.

Read docs/COLLABORATION.md before starting.

## New collaborator or AI? Start here
Read [the complete developer handoff](docs/AI_DEVELOPER_HANDOFF.md) for setup, library APIs, game development, testing and production linking. Its last section contains a prompt to give your AI.
