#!/usr/bin/env bash

set -o errexit

cd backend
(docker compose -f docker-compose.test.yml kill 2> /dev/null) || true
docker compose -f docker-compose.test.yml down
cd ..

# Try some or all of these commands if the repeated rebuilding of Docker containers leads to running out of disk space:
#
# docker stop $(docker ps --quiet) || true
# docker rm --force $(docker ps --quiet --all) || true
# docker volume prune --all --force
# docker compose --file backend/docker-compose.test.yml down --volumes --rmi local
# docker system prune --volumes --force

act -W .github/workflows/frontend-eslint.yml
act -W .github/workflows/frontend-type-checks.yml
act -W .github/workflows/frontend-playwright.yml --artifact-server-path $PWD/.frontend-playwright-artifacts
act -W .github/workflows/frontend-jest.yml

# I couldn't get nektos/act to work for backend-test.yml without using ubuntu-latest=-self-hosted, other than the mypy part.
act -W .github/workflows/backend-test.yml -j 'mypy'
act -W .github/workflows/backend-test.yml -P ubuntu-latest=-self-hosted -j 'functionality-tests-1'
act -W .github/workflows/backend-test.yml -P ubuntu-latest=-self-hosted -j 'functionality-tests-2'
act -W .github/workflows/backend-test.yml -P ubuntu-latest=-self-hosted -j 'functionality-tests-3'
act -W .github/workflows/backend-test.yml -P ubuntu-latest=-self-hosted -j 'functionality-tests-5'
act -W .github/workflows/backend-test.yml -P ubuntu-latest=-self-hosted -j 'functionality-tests-6'
act -W .github/workflows/backend-test.yml -P ubuntu-latest=-self-hosted -j 'unit-tests'
