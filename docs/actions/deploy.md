# core/deploy

Optionally verify an image's build provenance, then run the caller's own deploy script. The script receives DEPLOY_ENVIRONMENT and IMAGE as env vars, so each team keeps control of *how* they deploy (kubectl, helm, ssh, ...) while the library standardizes the gate in front of it.

```yaml title="Usage"
- uses: HamiltonHills/pipeline-actions/core/deploy@core/v1
  with:
    environment: ...
    script: ...
```

## Inputs

| Name | Required | Default | Description |
|---|---|---|---|
| `environment` | yes |  | Target environment name, passed to the script as DEPLOY_ENVIRONMENT |
| `script` | yes |  | Path (in the caller's repo) to an executable deploy script |
| `image` | no | `''` | Image reference pinned by digest (name@sha256:...). Empty for non-container deploys |
| `verify-attestation` | no | `false` | Verify the image's build provenance with gh attestation verify before deploying |
| `github-token` | no | `${{ github.token }}` | Token for attestation verification |

Source: [`core/deploy/action.yml`](https://github.com/HamiltonHills/pipeline-actions/blob/main/core/deploy/action.yml)
