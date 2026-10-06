#!/usr/bin/env bash
set -e

SONAR_HOST_URL="${SONAR_HOST_URL:-https://sonarcloud.io}"
SONAR_TOKEN="${SONAR_TOKEN:-49bdc1d9cf40b863554e0a0946a5f1cea2e33bff}"

echo "==> Running SonarCloud Scanner via Docker..."
docker run --rm \
  -v "$(pwd):/usr/src" \
  sonarsource/sonar-scanner-cli:latest \
  -Dsonar.token="${SONAR_TOKEN}"

echo "==> Scan selesai! Cek hasilnya di https://sonarcloud.io/project/overview?id=takahashiumaru_visitflow-agent-ai"
