# core/artifactory-upload

Upload files to a JFrog Artifactory repository with an access token. Sends SHA-256, SHA-1 and MD5 checksums so Artifactory verifies each upload, and attaches optional properties. Needs only bash, curl and coreutils, so it runs on minimal self-hosted runners.

```yaml title="Usage"
- uses: HamiltonHills/pipeline-actions/core/artifactory-upload@core/v1
  with:
    url: https://artifactory.example.com/artifactory
    repository: c-releases-local
    path: my-lib/1.2.3
    token: ${{ secrets.ARTIFACTORY_TOKEN }}
    files: |
      dist/*.tar.gz
      dist/*.sha256
```

## Inputs

| Name | Required | Default | Description |
|---|---|---|---|
| `url` | yes |  | Artifactory base URL, e.g. https://artifactory.example.com/artifactory |
| `repository` | yes |  | Target repository key, e.g. c-releases-local |
| `path` | no | `''` | Directory inside the repository to upload into, e.g. my-lib/1.2.3 |
| `files` | yes |  | Newline-separated file paths or globs to upload. Each pattern must match at least one file |
| `token` | yes |  | Artifactory access token (sent as a Bearer token) |
| `properties` | no | `''` | Semicolon-separated key=value properties to set on every file, e.g. vcs.revision=abc;build=42 |

## Outputs

| Name | Description |
|---|---|
| `urls` | Newline-separated URLs of the uploaded files |

## Token

Use an Artifactory **access token** scoped to deploy to the target repository,
not an admin token. In Artifactory, an identity token or a scoped token from
**Administration → User Management → Access Tokens** works. Store it as the
`ARTIFACTORY_TOKEN` secret at the org level, limited to the repos that publish.

Uploading to an existing path overwrites the file if the token has delete or
overwrite permission on that repository, and fails otherwise. For release
repositories, leave overwrite off so a published version can't be replaced.

Source: [`core/artifactory-upload/action.yml`](https://github.com/HamiltonHills/pipeline-actions/blob/main/core/artifactory-upload/action.yml)
