# vue/build

Install dependencies with npm ci, optionally lint, run tests (with coverage), and build a Vue/Vite app.

```yaml title="Usage"
- uses: HamiltonHills/pipeline-actions/vue/build@vue/v1
  with:
    working-directory: ...
```

## Inputs

| Name | Required | Default | Description |
|---|---|---|---|
| `working-directory` | no | `.` | Directory containing package.json |
| `node-version` | no | `22` | Node.js version (ignored when a .nvmrc or .node-version exists in working-directory) |
| `run-lint` | no | `false` | Run the lint script before testing |
| `lint-script` | no | `lint` | npm script that lints the app |
| `run-tests` | no | `true` | Run the test script before building |
| `test-script` | no | `test` | npm script that runs tests (should write coverage/lcov.info for Sonar) |
| `build-script` | no | `build` | npm script that builds the app |
| `dist-dir` | no | `dist` | Build output directory, relative to working-directory |
| `artifact-name` | no | `vue-dist` | Upload the build output as an artifact with this name (empty to skip) |

## Outputs

| Name | Description |
|---|---|
| `dist-path` | Path to the build output, relative to the workspace |

Source: [`vue/build/action.yml`](https://github.com/HamiltonHills/pipeline-actions/blob/main/vue/build/action.yml)
