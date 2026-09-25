# core-deploy.yml

Environment-gated deploy. `environment:` resolves in the **caller's** repo, so
each team's protection rules (required reviewers, branch rules, wait timers)
apply. Deploys to the same environment are serialized, never cancelled.

!!! note "Permissions the calling job must grant"
    contents: read, packages: read, id-token: write, attestations: read

```yaml title="Usage"
jobs:
  pipeline:
    uses: my-org/pipeline-actions/.github/workflows/core-deploy.yml@core/v1
    with:
      environment: ...
```

See [Examples](../examples.md) for a complete caller.

## Inputs

| Name | Type | Required | Default | Description |
|---|---|---|---|---|
| `environment` | string | yes |  |  |
| `deploy-script` | string | no | `deploy/deploy.sh` | Path in the caller's repo to the deploy script |
| `image` | string | no | `''` | Image pinned by digest (name@sha256:...) |
| `verify-attestation` | boolean | no | `false` | Requires the image to have been built with attest=true |
| `runs-on` | string | no | `ubuntu-latest` |  |

## Secrets

| Name | Required | Description |
|---|---|---|
| `DEPLOY_TOKEN` | no | Optional credential exposed to the deploy script as DEPLOY_TOKEN |

Source: [`.github/workflows/core-deploy.yml`](https://github.com/my-org/pipeline-actions/blob/main/.github/workflows/core-deploy.yml)
