# core/sonar-scan

Run SonarQube (Server or Cloud) analysis. Skips with a notice when no token is provided, so pipelines work in repos that haven't been onboarded to Sonar yet. The checkout should use fetch-depth 0 so Sonar can attribute new code.

```yaml title="Usage"
- uses: HamiltonHills/pipeline-actions/core/sonar-scan@core/v1
  with:
    token: ...
```

## Inputs

| Name | Required | Default | Description |
|---|---|---|---|
| `token` | no | `''` | SONAR_TOKEN |
| `host-url` | no | `''` | SonarQube Server URL. Leave empty for SonarQube Cloud |
| `project-base-dir` | no | `.` | Directory containing sonar-project.properties |
| `args` | no | `''` | Extra scanner arguments, e.g. -Dsonar.javascript.lcov.reportPaths=coverage/lcov.info |
| `require-token` | no | `false` | Fail instead of skipping when no token is provided |

Source: [`core/sonar-scan/action.yml`](https://github.com/HamiltonHills/pipeline-actions/blob/main/core/sonar-scan/action.yml)
