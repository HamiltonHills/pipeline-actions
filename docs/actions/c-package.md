# c/package

Install a CMake build into a staging directory and package it as a tarball with a SHA-256 checksum.

```yaml title="Usage"
- uses: my-org/pipeline-actions/c/package@c/v1
  with:
    name: ...
    version: ...
```

## Inputs

| Name | Required | Default | Description |
|---|---|---|---|
| `build-dir` | no | `build` | CMake build directory |
| `name` | yes |  | Package name |
| `version` | yes |  | Package version (e.g. 1.2.3 or 0.0.0-abc1234) |
| `output-dir` | no | `dist` | Where to write the tarball and checksum |

## Outputs

| Name | Description |
|---|---|
| `package-path` | Path to the .tar.gz |
| `checksum-path` | Path to the .sha256 file |
| `staging-dir` | Installed file tree (useful for SBOM generation) |

Source: [`c/package/action.yml`](https://github.com/my-org/pipeline-actions/blob/main/c/package/action.yml)
