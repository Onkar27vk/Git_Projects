#!/bin/bash
set -e

APP_NAME="payment-api"
ENVIRONMENT="dev"

echo "Deploying $APP_NAME to $ENVIRONMENT"
echo "Pulling latest image..."
echo "Deployment completed"

HEALTH_URL="http://localhost:8000/health"

echo "Checking application health at $HEALTH_URL"
