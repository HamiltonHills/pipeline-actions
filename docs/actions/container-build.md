# core/container-build

Build a container image with Buildx and GitHub Actions layer caching. With push=false the image is loaded into the local Docker daemon so it can be scanned before anything is published. With push=true it is pushed and the digest is returned.

```yaml title="Usage"
- uses: HamiltonHills/pipeline-actions/core/container-build@core/v1
  with:
    image-name: ...
```

## Inputs

| Name | Required | Default | Description |
|---|---|---|---|
| `image-name` | yes |  | Full image name without tag, e.g. ghcr.io/hamiltonhills/my-app (lowercase) |
| `context` | no | `.` | Build context directory |
| `dockerfile` | no | `''` | Path to the Dockerfile. Defaults to &lt;context&gt;/Dockerfile |
| `push` | no | `false` | Push to the registry (true) or load locally for scanning (false) |
| `build-args` | no | `''` | Newline-separated build args (KEY=value) |
| `registry` | no | `ghcr.io` | Registry to log in to when pushing |
| `registry-username` | no | `${{ github.actor }}` | Registry username (defaults to the workflow actor, which works for GHCR) |
| `registry-password` | no | `${{ github.token }}` | Registry password or token (defaults to GITHUB_TOKEN, which works for GHCR) |

## Outputs

| Name | Description |
|---|---|
| `image` | Image name without tag |
| `digest` | Pushed image digest (sha256:...). Empty when push=false |
| `local-ref` | First generated tag, usable for scanning a locally loaded image |
| `tags` | Newline-separated list of all generated tags |

Source: [`core/container-build/action.yml`](https://github.com/HamiltonHills/pipeline-actions/blob/main/core/container-build/action.yml)
