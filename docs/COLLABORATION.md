# Collaboration and new-game workflow

## Boundaries
Production: MUshihara/Serenity-hub. Development: MUshihara/SerenityHubv2.
Neither this repository nor its main branch automatically deploys into production.
Keep the user's public loader URL unchanged. Root loader.lua is intentionally a production forwarder.
Do not replace it with the example.

## Working together
Use one branch per game or feature and a pull request into v2 main.
Fetch the current branch before editing. Avoid simultaneous edits to shared UI bundles.
Review the diff and test PC/mobile before merging. Repository permissions and branch protection must be configured by the owner; this copy does not configure them.

## Adding a game
1. Copy games/example.lua to games/<game-name>.lua.
2. Give it distinct RuntimeKey and ConfigPath values.
3. Discover and verify the actual game's APIs before adding callbacks.
4. Add a guard using verified PlaceId/GameId values before any gameplay initialization.
5. Keep stable Page.Feature.Control IDs; saved values use these keys.
6. Use Action.Callback(window,adapter) for buttons and Changed(value,window,adapter) for value controls.
7. UI.Build returns app with Window, Adapter, Config and Runtime.
8. Register event connections using app.Runtime:TrackConnection and cancellation using TrackCleanup.
9. Do not assume saved settings invoke callbacks at startup; explicitly initialize your feature state from configuration.
10. Test repeat execution, cleanup, respawn, missing dependencies, and mobile interaction.

## UI and language maintenance
The readable dist/ui bundles are the baseline in this copy. Their historical generated-file comments refer to the original prototype; that prototype is not included and must not overwrite these newer bundles.
For localization, edit src/ui/localization and run:
python3 scripts/build-ui-locales.py
python3 scripts/test-ui-locales.py
Commit dictionaries and both updated UI bundles together.
Do not change internal control IDs when translating labels.

## Release to existing users
A merge here is development only. After the owner accepts in-game tests, prepare a separate reviewed production update with the new game's verified routing and required dependencies.
Use the current production routing format from the production repo at release time; do not guess or copy outdated game registrations.
If moving a library file into production, review its development repository URLs, test settings and service configuration first.
Do not point the production loader at the entire development main branch.
Keep a prior production commit for rollback.

## Services and credentials
The included Worker code is a reference, not a deployed replacement.
Never add Cloudflare secrets, API tokens or production webhook credentials to this public repository.
The shared presence entry can contact the existing production endpoint; use the direct universal adapter for isolated UI development as the example does.
Global chat/announcements remain a separate Phonk test and are not promoted here.
