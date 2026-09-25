# core/sbom

Generate an SBOM with Syft for a container image or a directory. Note: for C/C++ build output Syft can only see what carries package metadata (e.g. Conan/vcpkg manifests, dpkg databases). Hand-vendored or system-linked libraries will not appear unless declared in a manifest.

```yaml title="Usage"
- uses: my-org/pipeline-actions/core/sbom@core/v1
  with:
    image: ...
```

## Inputs

| Name | Required | Default | Description |
|---|---|---|---|
| `image` | no | `''` | Image reference to catalog (set this OR path) |
| `path` | no | `''` | Directory to catalog (set this OR image) |
| `format` | no | `cyclonedx-json` | SBOM format (cyclonedx-json or spdx-json) |
| `output-file` | no | `sbom.cdx.json` | Where to write the SBOM |
| `artifact-name` | no | `''` | Upload the SBOM as a workflow artifact with this name (empty to skip) |

## Outputs

| Name | Description |
|---|---|
| `path` | Path to the generated SBOM |

Source: [`core/sbom/action.yml`](https://github.com/my-org/pipeline-actions/blob/main/core/sbom/action.yml)
