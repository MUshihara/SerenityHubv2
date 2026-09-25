# Documentation

## Recommended Reading Order

1. [Repository Overview](../README.md)
2. [Developer Integration Guide](AI_DEVELOPER_HANDOFF.md)
3. [Contribution and Release Workflow](COLLABORATION.md)
4. [Reference Game Integration](../games/example.lua)

## Technical References

| Reference | Purpose |
| --- | --- |
| [Localization](UI_LOCALIZATION.md) | Maintain the ten-language interface |
| [Presence Service](ACTIVE_PRESENCE.md) | Understand statistics and heartbeat behavior |
| [Manifest Validator](../dist/core/manifest-validator.lua) | Verify accepted manifest fields and control types |
| [Runtime](../dist/core/runtime.lua) | Manage lifecycle and cleanup |
| [Configuration](../dist/core/config.lua) | Load, validate, and persist settings |
| [Universal Adapter](../dist/ui/universal-v3-2-0.lua) | Inspect the current Build and callback contracts |

## Documentation Scope

Development documentation describes this repository. Production integration requires a fresh review of the production repository and a separate release decision.

Files named `RELEASE-*.md` under `dist/ui/` are historical release references, not a declaration that development changes have been deployed.

Document test evidence precisely: syntax validation, mocked execution, and in-game verification are distinct results.
