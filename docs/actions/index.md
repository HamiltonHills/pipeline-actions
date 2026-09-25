# Actions

Composite actions are the building blocks. Reference them from a step with the
domain tag, e.g. `uses: my-org/pipeline-actions/core/trivy-scan@core/v1`.

| Action | Domain | Description |
|---|---|---|
| [`core/container-build`](container-build.md) | `core/v1` | Build a container image with Buildx and GitHub Actions layer caching. With push=false the image is loaded into the local Docker daemon so it can be scanned before anything is published. With push=true it is pushed and the digest is returned. |
| [`core/sbom`](sbom.md) | `core/v1` | Generate an SBOM with Syft for a container image or a directory. Note: for C/C++ build output Syft can only see what carries package metadata (e.g. Conan/vcpkg manifests, dpkg databases). Hand-vendored or system-linked libraries will not appear unless declared in a manifest. |
| [`core/trivy-scan`](trivy-scan.md) | `core/v1` | Scan a container image, a directory, or an SBOM for vulnerabilities with Trivy. |
| [`core/sonar-scan`](sonar-scan.md) | `core/v1` | Run SonarQube (Server or Cloud) analysis. Skips with a notice when no token is provided, so pipelines work in repos that haven't been onboarded to Sonar yet. The checkout should use fetch-depth 0 so Sonar can attribute new code. |
| [`core/deploy`](deploy.md) | `core/v1` | Optionally verify an image's build provenance, then run the caller's own deploy script. The script receives DEPLOY_ENVIRONMENT and IMAGE as env vars, so each team keeps control of *how* they deploy (kubectl, helm, ssh, ...) while the library standardizes the gate in front of it. |
| [`vue/build`](vue-build.md) | `vue/v1` | Install dependencies with npm ci, run tests (with coverage), and build a Vue/Vite app. |
| [`c/build`](c-build.md) | `c/v1` | Configure, build and test a CMake project. Always exports compile_commands.json, which Sonar's C/C++ analysis requires. |
| [`c/package`](c-package.md) | `c/v1` | Install a CMake build into a staging directory and package it as a tarball with a SHA-256 checksum. |
