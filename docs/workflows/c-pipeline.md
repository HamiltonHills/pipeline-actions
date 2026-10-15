# c-pipeline.yml

Complete pipeline for a CMake-based C project:

```text
build + test + sonar + package + sbom + trivy  ->  (on tags) GitHub release
                                               ->  (opt-in) Artifactory upload
```

!!! note "Permissions the calling job must grant"
    contents: write (for releases), id-token: write, attestations: write

```yaml title="Usage"
jobs:
  pipeline:
    uses: HamiltonHills/pipeline-actions/.github/workflows/c-pipeline.yml@c/v1
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
| `release-environment` | string | no | `release` | Environment gating the release job (created automatically if missing) |
| `attest` | boolean | no | `false` | Requires a public repo or GitHub Enterprise Cloud |
| `artifactory-publish` | boolean | no | `false` | Upload the package, its checksum and SBOM to Artifactory. Needs artifactory-url, artifactory-repository and the ARTIFACTORY_TOKEN secret |
| `artifactory-url` | string | no | `''` | Artifactory base URL, e.g. https://artifactory.example.com/artifactory |
| `artifactory-repository` | string | no | `''` | Target repository key, e.g. c-releases-local |
| `artifactory-path` | string | no | `''` | Directory inside the repository. Defaults to &lt;package-name&gt;/&lt;version&gt; |
| `runs-on` | string | no | `ubuntu-latest` | Runner label for the build and release jobs |
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

## Publishing to Artifactory

With `artifactory-publish: true`, an `artifactory` job uploads three files to
`<artifactory-repository>/<package-name>/<version>/`:

- `<name>-<version>-linux-<arch>.tar.gz`
- `<name>-<version>-linux-<arch>.tar.gz.sha256`
- `<name>-<version>.cdx.json` (the SBOM)

Each file gets the properties `vcs.url`, `vcs.revision`, `vcs.ref`, `version`
and `ci.run`, so you can search Artifactory for the commit or CI run that
produced a package.

On a `v*` tag the version is the tag without the `v`. On any other ref it's
`0.0.0-<short sha>`. To keep snapshots out of your release repository, publish
only on tags, or point non-tag builds at a separate repository:

```yaml
artifactory-publish: ${{ github.event_name == 'push' }}
artifactory-repository: ${{ startsWith(github.ref, 'refs/tags/v') && 'c-releases-local' || 'c-snapshots-local' }}
```

The upload runs on `artifactory-runs-on` when set, so the build can stay on
GitHub-hosted runners while only the upload uses a self-hosted runner inside
your network. See [Self-hosted runners](../things-to-know.md#self-hosted-runners).

Source: [`.github/workflows/c-pipeline.yml`](https://github.com/HamiltonHills/pipeline-actions/blob/main/.github/workflows/c-pipeline.yml)
