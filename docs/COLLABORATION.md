# Contribution and Release Workflow

## Repository Responsibilities

| Repository | Responsibility |
| --- | --- |
| MUshihara/SerenityHubv2 | Readable development source and integration testing |
| MUshihara/Serenity-hub | Production routing and released payloads |

A merge into the development repository does not deploy a production update. The root loader intentionally forwards to the existing production release.

## Contribution Process

1. Create a branch for one game, feature, or correction.
2. Review the current library contracts and relevant documentation.
3. Implement the smallest complete change.
4. Perform applicable checks and record their results.
5. Open a pull request describing the problem, changes, verification, and limitations.
6. Resolve review findings before merging.

Coordinate changes to shared UI bundles to avoid conflicting edits. Repository permissions and branch protection are configured separately by the owner.

## New-Game Development

Start with games/example.lua and follow the [Developer Integration Guide](AI_DEVELOPER_HANDOFF.md).

Each integration requires verified game identifiers, a distinct runtime key, a development configuration path, stable control IDs, and explicit cleanup. Initialize features from saved configuration rather than assuming startup callbacks will run.

## Shared Library Maintenance

The readable bundles in dist/ui are the current baseline. Historical generated-file comments reference an earlier prototype that is not included in this repository.

For localization changes, edit src/ui/localization and execute:

```sh
python3 scripts/build-ui-locales.py
python3 scripts/test-ui-locales.py
```

Commit the source dictionary and both generated translation bundles together. Do not rename gameplay control IDs as part of translation work.

## Production Release

Production release requires owner acceptance of the relevant test results.

1. Fetch the current production routing and entry contracts.
2. Prepare only the required game and dependency changes.
3. Review repository URLs, configuration paths, access checks, and external services.
4. Test the complete public-loader path.
5. Submit a separate production change for review.
6. Retain the previous production commit for rollback.

Do not redirect the public loader to the development main branch or replace the production library wholesale to register a single game.

## External Services

Worker source is a reference implementation and is not automatically deployed. Production secrets remain in the service configuration.

Use the direct universal adapter for isolated interface development. The shared entry may contact the production presence service.

Global chat and announcements remain a separate Phonk experiment and are outside the new-game starter.
