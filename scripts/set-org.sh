#!/usr/bin/env bash
# Replace the my-org/pipeline-actions placeholder with your real org/repo.
#   ./scripts/set-org.sh acme-corp/pipeline-actions
set -euo pipefail

target="${1:-}"
if ! [[ "$target" =~ ^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$ ]]; then
  echo "usage: $0 <org>/<repo>" >&2
  exit 1
fi
org="${target%%/*}"

cd "$(dirname "$0")/.."
grep -rl --exclude-dir=node_modules --exclude-dir=.git -e 'my-org' . \
  | grep -v '^./scripts/set-org.sh$' \
  | while read -r f; do
      sed -i.bak -e "s#my-org/pipeline-actions#$target#g" -e "s#@my-org/#@$org/#g" -e "s#my-org#$org#g" "$f"
      rm -f "$f.bak"
      echo "updated $f"
    done
