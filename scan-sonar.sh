#!/usr/bin/env bash
set -e

SONAR_HOST_URL="${SONAR_HOST_URL:-http://localhost:9000}"
SONAR_TOKEN="${SONAR_TOKEN:-}"
PROJECT_KEY="visitflow-agent-ai"

if [ -z "$SONAR_TOKEN" ]; then
  echo "Error: SONAR_TOKEN belum diset!"
  echo "Contoh pemakaian: SONAR_TOKEN=squ_xxx ./scan-sonar.sh"
  exit 1
fi

echo "==> Running SonarScanner via Docker..."
docker run --rm \
  --add-host=host.docker.internal:host-gateway \
  -v "$(pwd):/usr/src" \
  sonarsource/sonar-scanner-cli:latest \
  -Dsonar.host.url="http://host.docker.internal:9000" \
  -Dsonar.token="${SONAR_TOKEN}" \
  -Dsonar.projectKey="${PROJECT_KEY}" \
  -Dsonar.sources=src \
  -Dsonar.exclusions="node_modules/**,build/**,.svelte-kit/**,static/**,knowledge/**,datatags-agent-ai*"

echo "==> Scan selesai! Buka: ${SONAR_HOST_URL}/dashboard?id=${PROJECT_KEY}"
