# c/build

Configure, build and test a CMake project. Always exports compile_commands.json, which Sonar's C/C++ analysis requires.

```yaml title="Usage"
- uses: my-org/pipeline-actions/c/build@c/v1
  with:
    source-dir: ...
```

## Inputs

| Name | Required | Default | Description |
|---|---|---|---|
| `source-dir` | no | `.` | Directory containing CMakeLists.txt |
| `build-dir` | no | `build` | Build directory (relative to the workspace) |
| `build-type` | no | `Release` | CMAKE_BUILD_TYPE |
| `cmake-args` | no | `''` | Extra space-separated arguments for the configure step |
| `apt-packages` | no | `''` | Space-separated apt packages to install first (e.g. libssl-dev) |
| `run-tests` | no | `true` | Run ctest after building |

## Outputs

| Name | Description |
|---|---|
| `build-dir` | Absolute path to the build directory |
| `compile-commands` | Absolute path to compile_commands.json |

Source: [`c/build/action.yml`](https://github.com/my-org/pipeline-actions/blob/main/c/build/action.yml)
