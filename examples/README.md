# Consumer examples

These folders show the files an app team adds to **their own repo**. To try one
end to end, copy the matching fixture from `test-fixtures/` into a new repo and
then add these files on top:

| Example | Fixture to copy | Files to add |
|---|---|---|
| `vue-consumer/` | `test-fixtures/vue-app/` | `.github/workflows/ci.yml`, `deploy/deploy.sh`, `sonar-project.properties` |
| `c-consumer/`   | `test-fixtures/c-app/`   | `.github/workflows/ci.yml`, `sonar-project.properties` |

Sonar is skipped automatically until `SONAR_TOKEN` is set, so the pipelines run
before you've onboarded the project.
