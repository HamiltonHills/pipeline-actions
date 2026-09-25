# Versioning

Each domain is released independently from **Actions → release → Run
workflow**. Releasing `core` 1.3.0 creates `core/v1.3.0` and moves `core/v1`.

## Patch / minor

For example `core` 1.3.0 → 1.4.0: bug fixes, new *optional* inputs, bumped
third-party action pins. Consumers on `@core/v1` get these on their next run.

## Major

For example `core/v2`: removed or renamed inputs, changed outputs, or anything
that makes previously passing builds fail.

!!! warning "Tightening a security gate is a major change"
    Changing the default `trivy-severity` from `CRITICAL,HIGH` to include
    `MEDIUM` would break builds across the org, so ship it in a major and
    announce it. Teams can opt in early by setting the input themselves.

## Bumping core's major

The vue and c pipelines pin `@core/v1`. After releasing `core/v2`, update those
refs in a PR, then release `vue` and `c` (as majors if the core change affects
their consumers).
