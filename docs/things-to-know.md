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
app's directory to cover npm dependencies and committed secrets. In `vue/v2`
it only reports findings. Set `fail-on-source-findings: true` to make it a
gate. Failing by default would break builds that pass today, so it waits for
a major release.

## Self-hosted runners

Since v2, every reusable workflow defaults to `runs-on: self-hosted`, and so
does this library's own CI. Pass `runs-on: ubuntu-latest` to use
GitHub-hosted runners instead. `c-pipeline.yml` also takes
`artifactory-runs-on` to send only the upload to a different runner.

### What the runner needs

| Workflow | Needs on the runner |
|---|---|
| `vue-pipeline` | Docker with Buildx (for the image). Node is installed by the pipeline |
| `c-pipeline` with `container: ghcr.io/hamiltonhills/c-builder:1` | Docker only. The toolchain comes from the image ([Running in a container](workflows/c-pipeline.md#running-in-a-container)) |
| `c-pipeline` without a container | CMake, a C toolchain, `gh` for releases, passwordless `sudo apt-get` for `apt-packages` |
| `core-deploy` | whatever your deploy script uses |
| everything | bash, curl 7.76+, git, coreutils, and network access to GitHub, ghcr.io and Artifactory |

The runner's user must be in the `docker` group. Trivy and Syft download
their binaries and the Trivy database at run time, so a runner without
internet access needs internal mirrors for them.

### Runner groups and public repos

A repo can only use a runner whose group allows it (**Org settings → Actions
→ Runner groups**). This library is public, so its group must have **Allow
public repositories** checked.

A self-hosted runner on a public repo runs pull-request code inside your
network. This repo requires maintainer approval before Actions run for any
outside contributor (**Settings → Actions → General → Approval for running
fork pull request workflows → Require approval for all external
contributors**). Keep that setting, and review a fork's changes before
approving its run. App repos should stay private.

### Housekeeping

Unlike GitHub-hosted VMs, a self-hosted runner keeps state between jobs.
The workflows clean up after themselves: `core-container.yml` removes the
image it loaded for scanning, CI uses unique container names and random
ports, and `c-pipeline.yml`'s container jobs hand the files they wrote as
root back to the runner's user. If you run your own container jobs on a
shared runner, do the same, or the next job on the host fails with `EACCES`
in `_work`. Base images, build caches and the Trivy database still
accumulate, so prune on the runner weekly:

```bash
# /etc/cron.weekly/docker-prune
docker system prune -af --filter "until=168h"
```

One runner runs one job at a time. Add runners to the group as more repos
move over.
