# vue-pipeline.yml

Complete pipeline for a Vue/Vite app served from a container:

```text
build + test + sonar  ->  container (sbom, trivy, push, attest)  ->  deploy
```

!!! note "Permissions the calling job must grant"
    contents: read, packages: write, id-token: write, attestations: write

```yaml title="Usage"
jobs:
  pipeline:
    uses: my-org/pipeline-actions/.github/workflows/vue-pipeline.yml@vue/v1
```

See [Examples](../examples.md) for a complete caller.

## Inputs

| Name | Type | Required | Default | Description |
|---|---|---|---|---|
| `working-directory` | string | no | `.` |  |
| `node-version` | string | no | `22` |  |
| `image-name` | string | no | `''` | Defaults to ghcr.io/&lt;owner&gt;/&lt;repo&gt; |
| `push-image` | boolean | no | `false` | Push the image (typically only on pushes to main or tags) |
| `attest` | boolean | no | `false` | Requires a public repo or GitHub Enterprise Cloud |
| `trivy-severity` | string | no | `CRITICAL,HIGH` |  |
| `sonar-args` | string | no | `''` |  |
| `deploy-environment` | string | no | `''` | Environment to deploy to after a successful push (empty to skip) |
| `deploy-script` | string | no | `deploy/deploy.sh` |  |

## Secrets

| Name | Required | Description |
|---|---|---|
| `SONAR_TOKEN` | no |  |
| `SONAR_HOST_URL` | no |  |
| `DEPLOY_TOKEN` | no |  |

## Outputs

| Name | Description |
|---|---|
| `image` |  |
| `digest` |  |

Source: [`.github/workflows/vue-pipeline.yml`](https://github.com/my-org/pipeline-actions/blob/main/.github/workflows/vue-pipeline.yml)
