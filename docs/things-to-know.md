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

## npm dependencies are scanned from source, not the image

A Vue image only contains the built `dist/`, so the image scan can't see
`package-lock.json`. `vue-pipeline.yml` runs a Trivy filesystem scan of the
app's directory to cover npm dependencies and committed secrets. In `vue/v1`
it only reports findings. Set `fail-on-source-findings: true` to make it a
gate. Failing by default would break builds that pass today, so it waits for
a major release.

## Self-hosted runners

`vue-pipeline.yml` takes `runs-on`. `c-pipeline.yml` takes `runs-on` and
`artifactory-runs-on`. Both take a single runner label, such as `self-hosted`
or a custom label like `artifactory`.

What a self-hosted runner needs depends on the job it runs:

| Job | Needs on the runner |
|---|---|
| Artifactory upload | bash, curl 7.76+, coreutils (`sha256sum`, `sha1sum`, `md5sum`), network access to Artifactory and to GitHub |
| C build | CMake, a C toolchain, and passwordless `sudo apt-get` if you use `apt-packages` |
| C release | the GitHub CLI (`gh`) |
| Vue build, container | Node is installed by the pipeline. Docker with Buildx for the container job |

Trivy and Syft are downloaded by their actions. A runner without internet
access needs an internal mirror for their binaries and the Trivy database.

Runners are registered per org or repo under **Settings → Actions → Runners**.
For a runner that only uploads to Artifactory, give it a dedicated label
(e.g. `artifactory`) and set `artifactory-runs-on: artifactory`, so other jobs
can't land on it.
