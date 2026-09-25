#!/usr/bin/env bash
# Called by the library's deploy step with:
#   DEPLOY_ENVIRONMENT  e.g. staging
#   IMAGE               e.g. ghcr.io/acme/web@sha256:...   (always pinned by digest)
#   DEPLOY_TOKEN        optional secret passed through by your workflow
set -euo pipefail

echo "Deploying $IMAGE to $DEPLOY_ENVIRONMENT"

# Replace with however your team deploys, for example:
#
#   kubectl --context "$DEPLOY_ENVIRONMENT" -n web \
#     set image deployment/web web="$IMAGE"
#   kubectl --context "$DEPLOY_ENVIRONMENT" -n web \
#     rollout status deployment/web --timeout=5m
#
#   helm upgrade --install web ./chart \
#     --set image.ref="$IMAGE" -f "values-$DEPLOY_ENVIRONMENT.yaml" --wait
