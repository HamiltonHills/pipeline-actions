# c-pipeline.yml

Complete pipeline for a CMake-based C project:

```text
build + test + sonar + package + sbom + trivy  ->  (on release) GitHub release
                                               ->  (opt-in) Artifactory upload
```

!!! note "Permissions the calling job must grant"
    contents: write (for releases), id-token: write, attestations: write

```yaml title="Usage"
jobs:
  pipeline:
    uses: HamiltonHills/pipeline-actions/.github/workflows/c-pipeline.yml@c/v2
    with:
      package-name: ...
```

See [Examples](../examples.md) for a complete caller.

## Inputs

| Name | Type | Required | Default | Description |
|---|---|---|---|---|
| `package-name` | string | yes |  | Package name, used in the tarball name and the Artifactory path |
| `source-dir` | string | no | `.` | Directory containing CMakeLists.txt |
| `build-type` | string | no | `Release` | CMAKE_BUILD_TYPE |
| `cmake-args` | string | no | `''` | Extra space-separated arguments for the configure step |
| `apt-packages` | string | no | `''` | Space-separated apt packages to install first (e.g. libssl-dev) |
| `trivy-severity` | string | no | `CRITICAL,HIGH` | Comma-separated severities that count as findings |
| `sonar-args` | string | no | `''` | Extra Sonar scanner arguments |
| `release` | boolean | no | `false` | Publish a GitHub release. Only valid when triggered by a v* tag |
| `version` | string | no | `''` | Release this version (e.g. 1.4.0) from a manual run on the default branch: build and scan it, then tag v&lt;version&gt; on the built commit and publish the release. Empty for normal CI |
| `release-environment` | string | no | `release` | Environment gating the release job (created automatically if missing) |
| `attest` | boolean | no | `false` | Requires a public repo or GitHub Enterprise Cloud |
| `artifactory-publish` | boolean | no | `false` | Upload the package, its checksum and SBOM to Artifactory. Needs artifactory-url, artifactory-repository and the ARTIFACTORY_TOKEN secret |
| `artifactory-url` | string | no | `''` | Artifactory base URL, e.g. https://artifactory.example.com/artifactory |
| `artifactory-repository` | string | no | `''` | Target repository key, e.g. c-releases-local |
| `artifactory-path` | string | no | `''` | Directory inside the repository. Defaults to &lt;package-name&gt;/&lt;version&gt; |
| `runs-on` | string | no | `self-hosted` | Runner label for the build and release jobs. Use ubuntu-latest for GitHub-hosted |
| `artifactory-runs-on` | string | no | `''` | Runner label for the Artifactory upload job, e.g. a self-hosted runner that can reach your Artifactory. Defaults to runs-on |
| `container` | string | no | `''` | Image to run every job in, e.g. ghcr.io/hamiltonhills/c-builder:1. The runner then only needs Docker. Empty runs directly on the runner |

## Secrets

| Name | Required | Description |
|---|---|---|
| `SONAR_TOKEN` | no | Sonar token. Sonar is skipped with a notice when empty |
| `SONAR_HOST_URL` | no | SonarQube Server URL. Leave empty for SonarQube Cloud |
| `ARTIFACTORY_TOKEN` | no | Artifactory access token, required when artifactory-publish is true |

## Running in a container

Set `container: ghcr.io/hamiltonhills/c-builder:1` and every job (build,
release, Artifactory upload) runs inside that image. A self-hosted runner then
only needs Docker, and every build uses the same toolchain.

`c-builder` is built from [`images/c-builder`](https://github.com/HamiltonHills/pipeline-actions/tree/main/images/c-builder)
by `c-builder-image.yml`. It's Ubuntu 24.04 with GCC, CMake, Ninja,
pkg-config, git, gh, curl and jq. It's scanned before every push and rebuilt
weekly for security updates.

| Tag | Moves on |
|---|---|
| `c-builder:1` | every rebuild of 1.x (recommended) |
| `c-builder:1.0` | every rebuild of 1.0.x |
| `c-builder:1.0.0` | weekly security rebuilds only |
| `c-builder@sha256:...` | never |

A new major (`c-builder:2`) means a toolchain change that can break builds,
such as a new GCC major. Teams switch when they're ready.

Need extra packages? Either use `apt-packages` (it installs into the job's
container), or build your own image `FROM ghcr.io/hamiltonhills/c-builder:1`.
Use a Debian or Ubuntu base: JavaScript actions run the runner's Node inside
the container, which doesn't work on Alpine.

## Releasing

There are two ways to cut a release. Both publish a GitHub release with the
tarball, its checksum and the SBOM, and upload to Artifactory if you publish
there.

**From the Actions tab (recommended).** Give the caller a `version` input and
pass it through:

```yaml
on:
  workflow_dispatch:
    inputs:
      version:
        description: Release version without the v (e.g. 1.4.0). Empty for a normal CI run
        required: false

jobs:
  pipeline:
    uses: HamiltonHills/pipeline-actions/.github/workflows/c-pipeline.yml@c/v2
    with:
      version: ${{ inputs.version }}
      # ...
```

Then **Actions → ci → Run workflow**, on the default branch, with a version.
The build job checks the version first (`1.2.3` or `1.2.3-rc.1`, default
branch only, tag not taken), builds and scans that version, and only if
everything passes does the release job create `v<version>` on the commit it
built. A failed build or scan leaves no tag behind.

The tag is created with the workflow's token, which doesn't trigger other
workflows, so your tag-push CI doesn't run a second time.

**By pushing a tag.** Pass `release: true` on `v*` tags:

```yaml
release: ${{ startsWith(github.ref, 'refs/tags/v') }}
```

Tags created in the GitHub UI work too. The UI creates the release along with
the tag, so the pipeline attaches the package to that release instead of
creating one.

## Publishing to Artifactory

With `artifactory-publish: true`, an `artifactory` job uploads three files to
`<artifactory-repository>/<package-name>/<version>/`:

- `<name>-<version>-linux-<arch>.tar.gz`
- `<name>-<version>-linux-<arch>.tar.gz.sha256`
- `<name>-<version>.cdx.json` (the SBOM)

Each file gets the properties `vcs.url`, `vcs.revision`, `vcs.ref`, `version`
and `ci.run`, so you can search Artifactory for the commit or CI run that
produced a package.

On a release the version is the `version` input, or the tag without the `v`.
Otherwise it's `0.0.0-<short sha>`. To keep snapshots out of your release repository, publish
only on tags, or point non-tag builds at a separate repository:

```yaml
artifactory-publish: ${{ github.event_name == 'push' }}
artifactory-repository: ${{ (startsWith(github.ref, 'refs/tags/v') || inputs.version != '') && 'c-releases-local' || 'c-snapshots-local' }}
```

The upload runs on `artifactory-runs-on` when set, so the build can stay on
GitHub-hosted runners while only the upload uses a self-hosted runner inside
your network. See [Self-hosted runners](../things-to-know.md#self-hosted-runners).

Source: [`.github/workflows/c-pipeline.yml`](https://github.com/HamiltonHills/pipeline-actions/blob/main/.github/workflows/c-pipeline.yml)
