#!/usr/bin/env bash

# WARNING: this stops and deletes all Docker containers and volumes, possibly containers unrelated to Water or Duolicious

set -o errexit

# Remove cached images build from dockerfiles in this repository, so backend tests don't use old code. Also remove volumes and containers to prevent test failures caused by persisted state.
docker stop $(docker ps --quiet) || true
docker rm --force $(docker ps --quiet --all) || true
docker volume prune --all --force
docker compose --file backend/docker-compose.test.yml down --volumes --rmi local

# Prevent rapid disk space exhaustion caused by repeatedly deleting and rebuilding images
docker system prune --volumes --force

#act -W .github/workflows/frontend-eslint.yml
#act -W .github/workflows/frontend-type-checks.yml
#act -W .github/workflows/frontend-playwright.yml --artifact-server-path $PWD/.frontend-playwright-artifacts
#act -W .github/workflows/frontend-jest.yml
act -j 'functionality-tests-6' -W .github/workflows/backend-test.yml --concurrent-jobs 1 # Limiting to 1 concurrent job is a workaround to avoid docker container name collisions
