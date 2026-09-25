# Contributing

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

```yaml title="Safe input handling"
- run: ./build.sh "$TARGET"
  env:
    TARGET: ${{ inputs.target }}
```

## Docs

This site is built with [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/).
Pages live in `docs/`, navigation in `mkdocs.yml`. Run `uv run mkdocs serve`
to preview. Add or upgrade tools with `uv add` / `uv lock --upgrade` and commit
`uv.lock`. Pull requests run `mkdocs build --strict`, so broken links fail CI.
