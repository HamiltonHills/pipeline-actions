# Versioning

Each domain is released independently from **Actions → release → Run
workflow**. Releasing `core` 2.3.0 creates `core/v2.3.0` and moves `core/v2`.

## Patch / minor

For example `core` 2.3.0 → 2.4.0: bug fixes, new *optional* inputs, bumped
third-party action pins. Consumers on `@core/v2` get these on their next run.

## Major

For example `core/v3`: removed or renamed inputs, changed outputs, or anything
that makes previously passing builds fail.

!!! warning "Tightening a security gate is a major change"
    Changing the default `trivy-severity` from `CRITICAL,HIGH` to include
    `MEDIUM` would break builds across the org, so ship it in a major and
    announce it. Teams can opt in early by setting the input themselves.

## Bumping core's major

The vue and c pipelines pin `@core/v2`. After releasing `core/v3`, update those
refs in a PR, then release `vue` and `c` (as majors if the core change affects
their consumers).

## Upgrading from v1 to v2

v2 runs on the org's **self-hosted** runners by default. Every reusable
workflow's `runs-on` input now defaults to `self-hosted` instead of
`ubuntu-latest`. Nothing else changed.

1. Change `@vue/v1` → `@vue/v2`, `@c/v1` → `@c/v2` and `@core/v1` → `@core/v2`.
2. Make sure your repo can use the org runner group (**Org settings → Actions
   → Runner groups**).
3. C repos: add `container: ghcr.io/hamiltonhills/c-builder:1` unless your
   runner has the toolchain installed.

To stay on GitHub-hosted runners, pass `runs-on: ubuntu-latest`.
