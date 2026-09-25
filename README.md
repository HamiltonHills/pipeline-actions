# pipeline-actions

Shared GitHub Actions for building, scanning and shipping containers, Vue apps
and C projects. One repo, versioned by **domain**:

| Domain | Tag namespace | Contains |
|---|---|---|
| core | `core/v1` | container build, SBOM, Trivy, Sonar, deploy |
| vue  | `vue/v1`  | Vue/Vite build + `vue-pipeline.yml` |
| c    | `c/v1`    | CMake build, packaging + `c-pipeline.yml` |

A Vue team only sees `vue/*` releases, and a C team only sees `c/*` releases.
Both pick up shared fixes through `core`.

```
core/
  container-build/   build image; load locally (scan first) or push
  sbom/              Syft SBOM for an image or directory
  trivy-scan/        image | fs | sbom scanning
  sonar-scan/        SonarQube Server/Cloud; skips when no token
  deploy/            optional provenance check, then the caller's deploy script
vue/build/           npm ci, test (coverage), build, upload dist
c/build/             cmake configure/build/ctest, exports compile_commands.json
c/package/           install to staging, tar.gz + sha256
.github/workflows/
  core-container.yml   build -> sbom -> trivy -> push -> attest   (reusable)
  core-deploy.yml      environment-gated deploy                   (reusable)
  vue-pipeline.yml     full Vue pipeline                          (reusable)
  c-pipeline.yml       full C pipeline, releases on v* tags       (reusable)
  ci.yml               tests this library on every PR
  release.yml          cut a release for one domain
test-fixtures/       tiny Vue app and C app used by ci.yml
examples/            what app teams put in their repos
```

## Setup

1. **Create the repo** and push this code to `main`.

2. **Set your org name.** Every internal reference uses the placeholder
   `my-org/pipeline-actions`:
   ```bash
   ./scripts/set-org.sh acme/pipeline-actions
   ```
   This also updates the team names in `.github/CODEOWNERS`, so make sure
   those teams exist.

3. **Allow other repos to use it** (private or internal repos only):
   Settings → Actions → General → Access → *Accessible from repositories in
   the organization*.

4. **Cut the first releases, core first.** The pipelines reference
   `@core/v1`, `@vue/v1` and `@c/v1`, which don't exist until you release them.
   Go to Actions → release → Run workflow and run `core` 1.0.0, then
   `vue` 1.0.0, then `c` 1.0.0.

5. **Onboard an app.** Copy the files from `examples/vue-consumer` or
   `examples/c-consumer` into the app's repo. For Sonar, add `SONAR_TOKEN`
   (and `SONAR_HOST_URL` for SonarQube Server) as org or repo secrets. Until
   then the Sonar step is skipped with a notice.

## Versioning rules

- **Patch/minor** (`core` 1.3.0 → 1.4.0): bug fixes, new *optional* inputs,
  bumped third-party action pins. Consumers on `@core/v1` get these on their
  next run.
- **Major** (`core/v2`): removed or renamed inputs, changed outputs, or anything
  that makes previously passing builds fail. Tightening a security gate counts
  as major. Changing the default `trivy-severity` from `CRITICAL,HIGH` to
  include `MEDIUM` would break builds across the org, so ship it in a major and
  announce it. Teams can opt in early by setting the input themselves.
- **Bumping core's major:** the vue and c pipelines pin `@core/v1`. After
  releasing `core/v2`, update those refs in a PR, then release `vue` and `c`
  (as majors if the core change affects their consumers).

## Rules for contributors

- **Composite actions never call sibling actions.** Only the reusable
  workflows compose them. This lets `ci.yml` test every action from the PR's
  own code via `./` paths, and it keeps version coupling in one visible place.
- **Pin every third-party action to a full commit SHA** with the version in a
  comment. This library is a supply-chain choke point for the whole org.
  Dependabot keeps the pins current.
- **Never interpolate `${{ inputs.* }}` directly into `run:` scripts.** Pass
  inputs through `env:` and quote them, which prevents script injection.
- **Reusable workflows must stay flat in `.github/workflows/`.** The filename
  prefix (`core-`, `vue-`, `c-`) says which domain owns them.

## Things to know

- **Attestations** (`attest: true`) need a public repo or GitHub Enterprise
  Cloud. They are off by default so everything works on any plan. With them on,
  the deploy step verifies provenance before running the deploy script.
- **Callers must grant permissions.** A reusable workflow can only use
  permissions the calling job grants. Each workflow's header comment lists what
  it needs, and the examples grant exactly that.
- **Deploy environments resolve in the caller's repo**, so each team's
  protection rules apply. Environments are created automatically on first use.
  Add required reviewers under the app repo's Settings → Environments.
- **Deploy scripts belong to the app team.** The library runs the script with
  `DEPLOY_ENVIRONMENT`, `IMAGE` (pinned by digest) and an optional
  `DEPLOY_TOKEN`. The deploy job also has `id-token: write` for OIDC login to
  your cloud, which is preferable to long-lived tokens.
- **SBOMs for C** come from the installed file tree. Syft only finds
  dependencies that carry package metadata (Conan, vcpkg, dpkg). If your C
  projects vendor libraries by hand, those won't appear. Adopting a package
  manager or declaring vendored libraries in a manifest fixes that.
- **Sonar for C** gets `sonar.cfamily.compile-commands` passed automatically
  from the CMake build. Other build systems need to produce
  `compile_commands.json` (e.g. with Bear).
- **Scan before push.** `core-container.yml` builds the image locally, runs the
  SBOM and Trivy scans, and only pushes if they pass. The push reuses the
  layer cache, so the second build is fast.
