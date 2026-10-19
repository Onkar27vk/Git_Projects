#!/bin/bash
set -e

APP_NAME="payment-api"
echo "Deploying $APP_NAME"

echo "Deployment started at $(date)"

HEALTH_URL="http://localhost:8000/health"

if curl -fsS "$HEALTH_URL"; then
    echo "Health check passed"
else
    echo "Health check failed"
    exit 1
fi
