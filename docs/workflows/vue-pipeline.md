# vue-pipeline.yml

Complete pipeline for a Vue/Vite app served from a container:

```text
source scan + build + lint + test + sonar  ->  container (sbom, trivy, push, attest)  ->  deploy
```

The image only contains the built `dist/`, so the image scan can't see your
npm dependencies. The build job runs a Trivy filesystem scan of
`working-directory` to cover them: vulnerable packages in `package-lock.json`
and committed secrets. In v1 it reports findings without failing the build.
Set `fail-on-source-findings: true` to make it a gate.

!!! note "Permissions the calling job must grant"
    contents: read, packages: write, id-token: write, attestations: write

```yaml title="Usage"
jobs:
  pipeline:
    uses: HamiltonHills/pipeline-actions/.github/workflows/vue-pipeline.yml@vue/v1
```

See [Examples](../examples.md) for a complete caller.

## Inputs

| Name | Type | Required | Default | Description |
|---|---|---|---|---|
| `working-directory` | string | no | `.` | Directory containing package.json and the Dockerfile |
| `node-version` | string | no | `22` | Node.js version (ignored when a .nvmrc or .node-version exists in working-directory) |
| `run-lint` | boolean | no | `false` | Run the lint script before testing |
| `lint-script` | string | no | `lint` | npm script that lints the app |
| `run-tests` | boolean | no | `true` | Run the test script before building |
| `test-script` | string | no | `test` | npm script that runs tests. Should write coverage/lcov.info for Sonar |
| `build-script` | string | no | `build` | npm script that builds the app |
| `dist-dir` | string | no | `dist` | Build output directory, relative to working-directory |
| `fail-on-source-findings` | boolean | no | `false` | Fail the build when the source scan (npm dependencies from package-lock.json, committed secrets) finds issues at trivy-severity. Off by default: findings are reported but don't fail the build |
| `container` | boolean | no | `true` | Build, scan and optionally push the image. false stops after the build job (no image, no deploy) |
| `image-name` | string | no | `''` | Defaults to ghcr.io/&lt;owner&gt;/&lt;repo&gt; |
| `dockerfile` | string | no | `''` | Defaults to &lt;working-directory&gt;/Dockerfile |
| `build-args` | string | no | `''` | Newline-separated Docker build args (KEY=value) |
| `push-image` | boolean | no | `false` | Push the image (typically only on pushes to main or tags) |
| `attest` | boolean | no | `false` | Requires a public repo or GitHub Enterprise Cloud |
| `trivy-severity` | string | no | `CRITICAL,HIGH` | Comma-separated severities that count as findings in the source and image scans |
| `sonar-args` | string | no | `''` | Extra Sonar scanner arguments |
| `deploy-environment` | string | no | `''` | Environment to deploy to after a successful push (empty to skip) |
| `deploy-script` | string | no | `deploy/deploy.sh` | Path in the caller's repo to the deploy script |
| `runs-on` | string | no | `ubuntu-latest` | Runner label for every job, e.g. self-hosted to reach a SonarQube server on a private network |

## Secrets

| Name | Required | Description |
|---|---|---|
| `SONAR_TOKEN` | no | Sonar token. Sonar is skipped with a notice when empty |
| `SONAR_HOST_URL` | no | SonarQube Server URL. Leave empty for SonarQube Cloud |
| `DEPLOY_TOKEN` | no | Optional credential exposed to the deploy script as DEPLOY_TOKEN |

## Outputs

| Name | Description |
|---|---|
| `image` | Image name without tag (empty when container is false) |
| `digest` | Pushed image digest (empty unless push-image is true) |

Source: [`.github/workflows/vue-pipeline.yml`](https://github.com/HamiltonHills/pipeline-actions/blob/main/.github/workflows/vue-pipeline.yml)
