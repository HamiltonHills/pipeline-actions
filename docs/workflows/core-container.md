# core-container.yml

```text
build -> SBOM -> Trivy scan -> (push -> attest)
```

The image is scanned while it only exists on the runner; nothing is pushed
unless the scan passes.

!!! note "Permissions the calling job must grant"
    contents: read, packages: write, id-token: write, attestations: write

```yaml title="Usage"
jobs:
  pipeline:
    uses: HamiltonHills/pipeline-actions/.github/workflows/core-container.yml@core/v1
```

See [Examples](../examples.md) for a complete caller.

## Inputs

| Name | Type | Required | Default | Description |
|---|---|---|---|---|
| `image-name` | string | no | `''` | Full image name without tag. Defaults to ghcr.io/&lt;owner&gt;/&lt;repo&gt; |
| `context` | string | no | `.` |  |
| `dockerfile` | string | no | `''` | Defaults to &lt;context&gt;/Dockerfile |
| `build-args` | string | no | `''` |  |
| `download-artifact` | string | no | `''` | Artifact to download before building (e.g. a prebuilt dist/) |
| `download-path` | string | no | `''` | Where to put the downloaded artifact |
| `push` | boolean | no | `false` |  |
| `attest` | boolean | no | `false` | Create provenance + SBOM attestations for the pushed image. Requires a public repo or GitHub Enterprise Cloud. |
| `trivy-severity` | string | no | `CRITICAL,HIGH` |  |
| `runs-on` | string | no | `ubuntu-latest` |  |

## Outputs

| Name | Description |
|---|---|
| `image` | Image name without tag |
| `digest` | Pushed digest (empty when push is false) |

Source: [`.github/workflows/core-container.yml`](https://github.com/HamiltonHills/pipeline-actions/blob/main/.github/workflows/core-container.yml)
