# core/trivy-scan

Scan a container image, a directory, or an SBOM for vulnerabilities with Trivy.

```yaml title="Usage"
- uses: my-org/pipeline-actions/core/trivy-scan@core/v1
  with:
    target: ...
```

## Inputs

| Name | Required | Default | Description |
|---|---|---|---|
| `scan-type` | no | `image` | One of image, fs, sbom |
| `target` | yes |  | Image reference (image), directory (fs), or SBOM file path (sbom) |
| `severity` | no | `CRITICAL,HIGH` | Comma-separated severities that count as findings |
| `ignore-unfixed` | no | `true` | Ignore vulnerabilities that have no fix available yet |
| `fail-on-findings` | no | `true` | Fail the step when findings at the given severities exist |
| `trivyignores` | no | `''` | Comma-separated list of .trivyignore files to apply |

Source: [`core/trivy-scan/action.yml`](https://github.com/my-org/pipeline-actions/blob/main/core/trivy-scan/action.yml)
