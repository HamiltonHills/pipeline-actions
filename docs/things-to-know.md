# Things to know

!!! info "Attestations"
    `attest: true` needs a public repo or GitHub Enterprise Cloud. It is off by
    default so everything works on any plan. With it on, the deploy step
    verifies provenance before running the deploy script.

## Callers must grant permissions

A reusable workflow can only use permissions the calling job grants. Each
workflow's header comment lists what it needs, and the examples grant exactly
that. See the [workflow reference](workflows/index.md).

## Deploy environments resolve in the caller's repo

Each team's protection rules apply. Environments are created automatically on
first use. Add required reviewers under the app repo's **Settings →
Environments**.

## Deploy scripts belong to the app team

The library runs the script with `DEPLOY_ENVIRONMENT`, `IMAGE` (pinned by
digest) and an optional `DEPLOY_TOKEN`. The deploy job also has
`id-token: write` for OIDC login to your cloud, which is preferable to
long-lived tokens.

## SBOMs for C

SBOMs for C come from the installed file tree. Syft only finds dependencies
that carry package metadata (Conan, vcpkg, dpkg). If your C projects vendor
libraries by hand, those won't appear. Adopting a package manager or declaring
vendored libraries in a manifest fixes that.

## Sonar for C

`sonar.cfamily.compile-commands` is passed automatically from the CMake build.
Other build systems need to produce `compile_commands.json` (e.g. with Bear).

## Scan before push

`core-container.yml` builds the image locally, runs the SBOM and Trivy scans,
and only pushes if they pass. The push reuses the layer cache, so the second
build is fast.
