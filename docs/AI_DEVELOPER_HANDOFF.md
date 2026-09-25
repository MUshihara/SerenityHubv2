# Serenity library: collaborator and AI handoff

Verified against the repositories on 2026-09-25. Read current source before making changes; this document is a starting point, not a substitute for inspection.

## 1. Understand the two repositories

| Repository | Purpose | Does merging here update existing users? |
| --- | --- | --- |
| MUshihara/SerenityHubv2 | Readable library, development and new-game work | No |
| MUshihara/Serenity-hub | Existing public release and game routing | Changes to paths used by the loader can affect users |

The public entry remains:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/MUshihara/Serenity-hub/main/loader.lua"))()
```

The v2 root loader forwards to that production entry. It is NOT a development game selector. Uploading a file under v2/games does not register a supported game, and running the public loader will not discover that file automatically.

There are two separate meanings of integration:
1. A game script builds its interface using the Serenity library.
2. The public production router recognizes the game's verified IDs and loads its released script.
Complete and test the first before requesting the second.

## 2. Access and tools needed

- Your own GitHub account, invited to the development repository.
- Your AI's GitHub connection granted access to that repository, if using an AI connector.
- A feature branch and pull request workflow. Do not share account passwords or personal access tokens.
- A text editor or AI coding workspace; Python 3 is needed for localization tooling.
- An appropriate authorized runtime to test the supplied library, plus PC and mobile testing where supported.
- Verified game PlaceId/GameId, feature requirements and evidence of the actual APIs used.

This library is Luau but uses environment-specific facilities such as loadstring, game:HttpGet, optional executor filesystem functions and clipboard providers. It is not a drop-in Roblox Studio ModuleScript package. A Studio-native game needs supported module loading and appropriate client/server architecture instead. Do not assume a clipboard or file API exists on every device.

The repository is public. Never commit cloud secrets, webhook credentials, tokens, personal logs or credentials from diagnostic output.

## 3. Files to read first

1. AGENTS.md and README.md.
2. docs/COLLABORATION.md and this document.
3. games/example.lua: the smallest working integration example.
4. dist/core/manifest-validator.lua: actual accepted manifest structure.
5. The Build function at the end of dist/ui/universal-v3-2-0.lua: actual callback and return contracts.
6. dist/core/runtime.lua and dist/core/config.lua.
7. docs/UI_LOCALIZATION.md for translations.
8. docs/ACTIVE_PRESENCE.md only when working on stats integration.

## 4. What is in this copy

| Location | Responsibility |
| --- | --- |
| games/ | Readable new-game scripts; start with one file per game |
| dist/ui/universal-v3-2-0.lua | Current bundled UI and adapter for new V3 games |
| dist/ui/phonk-v3-1-0.lua | Existing Phonk-specific adapter; do not use it as the default for new games |
| dist/ui/serenity-v3.lua | Shared selection entry, presence startup and Discord notification integration |
| dist/core/ | Validation, lifecycle, configuration, device routing and compatibility code |
| src/ui/localization/ | Local dictionary and translation runtime |
| scripts/ | Translation build and verification tools |
| services/active-counter/ | Backend reference source/tests, not an automatically deployed service |

Legacy UI files remain to satisfy existing compatibility routes. They are not the starting point for new games. No obfuscated game implementations were copied; the collaborator must provide readable gameplay logic.

The current bundles are readable and are the baseline. Their generated-file comments refer to an older prototype not included here. Do not rebuild from an unrelated old prototype and overwrite the current UI.

## 5. Start a new game

1. Create a branch, for example game/my-game.
2. Copy games/example.lua to games/my-game.lua.
3. Confirm game.GameId (universe ID) and game.PlaceId (current place ID). Decide whether the feature supports the whole universe or only particular places.
4. Add an ID guard before gameplay initialization. Use actual verified IDs, never a guessed name match.
5. Set a truthful GameName, unique RuntimeKey and separate development ConfigPath.
6. Load the universal adapter directly during isolated development, as the example does.
7. Build one harmless control, then one verified feature, before expanding.

Run the existing demonstration with:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/MUshihara/SerenityHubv2/main/games/example.lua"))()
```

For a branch, substitute its actual ref in the raw URL. Important: changing only the outer script URL does not redirect its dependencies. The current library bundles fetch shared core from v2/main. To test modified library/core files on a branch, review and redirect their internal development URLs too. A commit-pinned entry does not make transitive main URLs immutable.

## 6. Manifest and API contract

The manifest is a table with SerenityAPIVersion=3, GameName and a nonempty Pages array. Each page has Id, Title and Features. Each feature has Id, Title and Controls. Each control needs Type and, except for Paragraph, an Id. Use Title for the visible label.

The stable configuration key is PageId.FeatureId.ControlId. Change visible labels freely; changing these IDs can break saved settings and control lookups.

| Type | Main contract |
| --- | --- |
| Action | Callback(window, adapter) |
| Switch | Boolean Default; Changed(value, window, adapter) |
| Select | Nonempty Options; Default must be an option |
| MultiSelect | Options, table Default, explicit EmptyMeansAll boolean |
| Slider | Numeric Min < Max and appropriate Default |
| Input | Text value; inspect the current control implementation for extra properties |
| Live | Display-only value, updated through Adapter:SetLive |
| Progress | Display value/range; Min < Max when both provided |
| Paragraph | Informational Title/Text |

Value controls use Changed or fall back to Callback. Callbacks run asynchronously with protected error reporting. They are not serialized, so your feature must prevent overlapping work. Read the current validator/control implementation before using optional fields; do not invent API names from other UI libraries.

```lua
local app = UI.Build(manifest, {
    RuntimeKey = manifest.RuntimeKey,
    ConfigPath = manifest.ConfigPath,
})

local enabled = app.Config:Get("Example.Controls.Enabled", false)
app.Window:Notify("Example", "Ready")
-- Update a Live control that actually exists in your manifest:
-- app.Adapter:SetLive("Dashboard.Status.Count", count)
-- Stop the UI and owned resources:
-- app:Destroy()
```

Build returns app.Window, app.Adapter, app.Config, app.Runtime, app.Profile and app.Manifest. The example notification is demonstration text, not evidence that gameplay succeeded.

The adapter supplies shared About and Settings pages. Reserved page IDs can be renamed internally (for example Settings becomes Game_Settings). Prefer distinctive game page IDs to avoid ambiguity.

## 7. Configuration and lifecycle

Config:Get(key, fallback) returns saved/default state. Config:Set(key, value, silent) changes state; normal value-control callbacks already save through the adapter. SaveSoon is debounced; SaveNow is explicit. Persistence requires the environment's file APIs; without them settings are session-only.

The current config loader checks top-level types against defaults. It does not fully validate ranges, nested arrays or game-specific values. Validate those yourself. Saved values are not guaranteed to trigger Changed on startup: explicitly initialize your feature state from app.Config after Build.

Runtime provides TrackConnection, TrackCleanup, TrackChild and Destroy. Reusing the same RuntimeKey destroys the previous owner for that key. It does not clean up unrelated untracked tasks or persist identity across rejoins.

```lua
local stopped = false
app.Runtime:TrackCleanup(function()
    stopped = true
end)

-- For each real event connection:
-- app.Runtime:TrackConnection(event:Connect(function(...) ... end))
```

Track and cancel your workers, or make them exit on stopped/app.Runtime.Destroyed. Avoid spawning a fresh loop every time a toggle is clicked. Re-check state after yielding. Use bounded retries, verify outcomes and coordinate conflicting actions.

Keep initial gameplay actions disabled in the starter. Only add them after inspecting actual game source/interfaces within an authorized environment.

## 8. Languages and UI

Supported languages: English, Filipino, Indonesian, Vietnamese, Thai, Spanish, Brazilian Portuguese, French, German and Russian. Initial default is English; a saved manual preference can be restored.

Fixed strings use local dictionaries, not a translation API. New phrases remain English until dictionary entries are added. Edit src/ui/localization/translations.txt with the ten columns documented in docs/UI_LOCALIZATION.md, then run:

```sh
python3 scripts/build-ui-locales.py
python3 scripts/test-ui-locales.py
```

Commit the dictionary and both rebuilt bundles. Preserve placeholders and internal IDs. Verify long text on mobile. Do not change the global scale/layout to fix one game's long label.

The copied UI retains some shared release text. Review user-facing About/status information before a new production release rather than assuming every bundled label describes the new game.

## 9. Stats, Discord, feedback and chat

- Direct universal-adapter development does not start the shared presence heartbeat or shared startup Discord notice.
- The shared serenity-v3 entry starts those integrations. Its current presence endpoint is the existing production Worker, even in this development copy.
- If testing the shared entry without stats, set getgenv().SerenityPresenceEnabled=false before Build where getgenv is available. Restore the intended setting for a real release. This opt-out does not disable Discord notification logic.
- Do not add a second presence loop. Read docs/ACTIVE_PRESENCE.md for the actual payload and expiry contract.
- PRESENCE_HMAC_SECRET belongs on the Worker server. Neither a game client nor a collaborator building a stats display needs it.
- The current invite is https://discord.gg/pWPs7428wE. Clipboard support depends on the environment; do not promise it always works.
- Production feedback webhook credentials were deliberately removed from this copy. Feedback is not configured merely because its UI is present. Integrating a destination requires explicit owner configuration; never reinsert secrets into this public repository.
- Global chat and announcements remain a separate Phonk-only experiment. They are not included in new games by this starter and are not approved for a broad rollout.

## 10. Connect the finished game to the public loader

This is an owner-reviewed production release step, not a side effect of saving a game file.

The inspected production structure is currently mixed: root loader.lua directly routes several games and sends other games to dist/loader.lua. The latter selects game entries, often under dist/games/. The inspected Phonk entry invokes dist/access-v2/payload-guard.lua before its runtime payload. Do not assume every game follows exactly the same route.

Release procedure:
1. Provide the tested readable source, verified IDs, feature list and test results to the owner.
2. Fetch current production loader.lua, dist/loader.lua and the relevant entry/guard contracts again.
3. Choose one appropriate routing path consistent with current production conventions. Preserve existing access checks; do not copy private authorization flags into the game as a workaround.
4. Prepare the game's release entry and payload paths with the owner. Keep editable source in v2. Any release packaging is a separate process.
5. Use the production shared UI entry for the released game if the normal stats/Discord integration is required. Inspect the current production library before finalizing compatibility.
6. Review every dependency URL. A released game must not accidentally depend on unfinished v2/main library changes.
7. Add detection using verified IDs, preserving existing routing precedence and unrelated games.
8. Test the full public-loader path in the target game and an existing game.
9. Merge the reviewed release and retain a rollback commit. Existing public loadstrings remain identical.

Do not bulk-copy the development library over production merely to add one game. Only release the required, reviewed changes. Files in services are not deployed to Cloudflare by a GitHub commit here.

## 11. Completion evidence to hand to the owner

- Game name, universe ID and supported place IDs.
- Development commit and exact test loader.
- Source file path, RuntimeKey and ConfigPath.
- Manifest/control IDs and feature behavior.
- Dependencies and any requested shared-library change.
- Actual PC/mobile test results, with untested areas clearly identified.
- Repeat execution, toggling, saved settings, respawn and cleanup results.
- Failure handling and performance observations.
- Production routing proposal, changed-file list and rollback plan.

Syntax checks and mocked tests do not prove in-game operation. Do not claim obfuscated payload internals were reviewed when their readable source is unavailable.

## 12. Prompt to give the collaborator's AI

```text
We are developing a new game integration using MUshihara/SerenityHubv2.
Read AGENTS.md, README.md, docs/AI_DEVELOPER_HANDOFF.md,
docs/COLLABORATION.md and games/example.lua first. Then inspect the
current manifest validator, universal adapter Build function, Runtime
and Config APIs. Treat source as authoritative.

Game: [name and link]
Verified universe/place IDs: [IDs, or investigate before using]
Requested features: [list]
Available readable source/diagnostic evidence: [attachments or paths]

Work in a feature branch. Start with the existing universal-library
example and add one verified feature at a time. Keep stable control IDs,
unique development configuration and tracked cleanup. Use local
translation dictionaries. Test PC and mobile and repeated execution.

Do not modify the production repository or public loader as part of
development. Do not deploy services, include secrets, add duplicate
presence loops, bypass existing access checks, or promote the separate
chat experiment. Prepare an explicit production integration proposal
after the owner accepts tests. The public loader URL must stay unchanged.
Clearly distinguish verified results from assumptions and tests I must run.
```
