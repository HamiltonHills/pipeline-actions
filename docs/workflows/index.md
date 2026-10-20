# Workflows

Reusable workflows compose the actions into complete pipelines. Call them from
a job with `uses:` and grant the permissions each one lists.

| Workflow | Tag | Summary |
|---|---|---|
| [`vue-pipeline.yml`](vue-pipeline.md) | `vue/v2` | Complete pipeline for a Vue/Vite app served from a container: |
| [`c-pipeline.yml`](c-pipeline.md) | `c/v2` | Complete pipeline for a CMake-based C project: |
| [`core-container.yml`](core-container.md) | `core/v2` | Build -&gt; SBOM -&gt; Trivy scan -&gt; (push -&gt; attest) |
| [`core-deploy.yml`](core-deploy.md) | `core/v2` | Environment-gated deploy. `environment:` resolves in the CALLER's repo, so |
