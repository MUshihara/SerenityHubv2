# Agent Instructions

## Required Reading

Read README.md, docs/AI_DEVELOPER_HANDOFF.md, and docs/COLLABORATION.md before making changes. Inspect the current implementation before relying on documented API behavior.

## Development Scope

- Use this repository for readable library maintenance and game integration.
- Preserve the existing production loader URL.
- Do not modify or deploy the production repository without explicit release authorization.
- Keep new game implementations in separate files with verified identifiers and interfaces.
- Preserve stable control IDs, configuration compatibility, and tracked lifecycle cleanup.
- Do not commit credentials, private diagnostic data, or obfuscated payloads.

## Verification and Reporting

Use targeted checks appropriate to the change. Distinguish syntax checks, mocked tests, and in-game results. Report unverified behavior explicitly.

Update the relevant documentation when an API, dependency, configuration format, or release procedure changes.
