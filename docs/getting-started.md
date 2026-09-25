# Getting started

## 1. Create the repo

Create the repo and push this code to `main`.

## 2. Set your org name

Every internal reference uses the placeholder `my-org/pipeline-actions`:

```bash
./scripts/set-org.sh acme/pipeline-actions
```

This also updates the team names in `.github/CODEOWNERS`, so make sure those
teams exist.

## 3. Allow other repos to use it

For private or internal repos only:
**Settings → Actions → General → Access →** *Accessible from repositories in
the organization*.

## 4. Cut the first releases, core first

The pipelines reference `@core/v1`, `@vue/v1` and `@c/v1`, which don't exist
until you release them. Go to **Actions → release → Run workflow** and run:

1. `core` 1.0.0
2. `vue` 1.0.0
3. `c` 1.0.0

## 5. Onboard an app

Copy the files from `examples/vue-consumer` or `examples/c-consumer` into the
app's repo. See [Examples](examples.md).

!!! tip "Sonar is optional at first"
    Add `SONAR_TOKEN` (and `SONAR_HOST_URL` for SonarQube Server) as org or
    repo secrets. Until then the Sonar step is skipped with a notice.

## 6. Publish these docs (optional)

The `docs.yml` workflow deploys this site to GitHub Pages on pushes to `main`.
Enable it under **Settings → Pages → Source → GitHub Actions**.

Preview locally with [uv](https://docs.astral.sh/uv/):

```bash
uv run mkdocs serve
```

uv installs the right Python and the pinned dependencies from `uv.lock` on
first run.
