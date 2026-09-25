# SerenityHubv2

Development library and integration workspace for Serenity Hub.

This repository contains readable interface components, shared runtime modules, localization resources, and a reference game integration. It supports collaborative development while maintaining a separate production release process.

## Repository Status

| Item | Description |
| --- | --- |
| Purpose | Library maintenance and new-game development |
| Production repository | [MUshihara/Serenity-hub](https://github.com/MUshihara/Serenity-hub) |
| Deployment | Separate, reviewed production release |
| Game implementations | Readable reference example; existing obfuscated payloads are excluded |
| Validation | Example syntax checked; in-game validation required |

Merging changes into this repository does not update the production loader or register a supported game.

## Documentation

| Document | Scope |
| --- | --- |
| [Documentation Index](docs/README.md) | Documentation structure and recommended reading order |
| [Developer Integration Guide](docs/AI_DEVELOPER_HANDOFF.md) | Environment requirements, library APIs, testing, and production integration |
| [Contribution and Release Workflow](docs/COLLABORATION.md) | Branches, review requirements, and release responsibilities |
| [Localization Reference](docs/UI_LOCALIZATION.md) | Supported languages, dictionary maintenance, and build procedures |
| [Presence Service Reference](docs/ACTIVE_PRESENCE.md) | Account presence, execution statistics, and backend contracts |
| [Agent Instructions](AGENTS.md) | Requirements for AI-assisted contributions |

## Repository Structure

| Directory | Contents |
| --- | --- |
| `games/` | Reference integration and future readable game modules |
| `dist/core/` | Manifest validation, configuration, lifecycle, and device routing |
| `dist/ui/` | Readable UI bundles and compatibility dependencies |
| `src/ui/localization/` | Translation dictionaries and localization runtime |
| `scripts/` | Localization build and verification tools |
| `services/active-counter/` | Presence service reference implementation and tests |
| `docs/` | Development and integration documentation |

Existing dependency paths are retained. Static artwork uses the existing pinned asset source.

## Development Example

Review [games/example.lua](games/example.lua) before execution. The example demonstrates interface construction and notifications without gameplay automation or shared presence reporting.

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/MUshihara/SerenityHubv2/main/games/example.lua"))()
```

The supplied library requires an environment compatible with its loading APIs. It is not a directly installable Roblox Studio ModuleScript package. Refer to the integration guide for requirements and limitations.

## Production Entry Point

The existing public loader remains:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/MUshihara/Serenity-hub/main/loader.lua"))()
```

The root `loader.lua` in this repository forwards to that production entry. It does not load development modules from `games/`.

## Configuration and External Services

- Internal library dependencies resolve to this development repository.
- The shared entry retains the existing production presence endpoint. Use the direct universal adapter for isolated interface testing.
- Embedded production feedback webhook credentials are excluded. A feedback destination requires separate configuration.
- Backend source files are provided for reference; repository changes do not deploy services.
- The separate Phonk chat and announcement experiment is not included in the new-game starter.

Do not commit credentials, tokens, or private diagnostic data.

## Source Baseline

The initial library copy was prepared on 25 September 2026 from production tree `f51b50ad5ddc6b3a2bd3ebb54f6e488232614710`.

The current source code is authoritative. Review repository changes before applying instructions from an earlier handoff.
