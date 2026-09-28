# c-pipeline.yml

Complete pipeline for a CMake-based C project:

```text
build + test + sonar + package + sbom + trivy  ->  (on tags) GitHub release
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
| `package-name` | string | yes |  |  |
| `source-dir` | string | no | `.` |  |
| `build-type` | string | no | `Release` |  |
| `cmake-args` | string | no | `''` |  |
| `apt-packages` | string | no | `''` |  |
| `trivy-severity` | string | no | `CRITICAL,HIGH` |  |
| `sonar-args` | string | no | `''` |  |
| `release` | boolean | no | `false` | Publish a GitHub release. Only valid when triggered by a v* tag |
| `release-environment` | string | no | `release` | Environment gating the release job (created automatically if missing) |
| `attest` | boolean | no | `false` | Requires a public repo or GitHub Enterprise Cloud |

## Secrets

| Name | Required | Description |
|---|---|---|
| `SONAR_TOKEN` | no |  |
| `SONAR_HOST_URL` | no |  |

Source: [`.github/workflows/c-pipeline.yml`](https://github.com/HamiltonHills/pipeline-actions/blob/main/.github/workflows/c-pipeline.yml)
