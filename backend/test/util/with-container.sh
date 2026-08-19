#!/usr/bin/env bash

set -e

# The postgresql-client installation step is a workaround to make .github/workflows/backend-test.yml work in the partial image used by nektos/act.
#if [ -v ACT ]; then
#  sudo apt-get update
#  sudo apt-get install -y postgresql-client
#fi

docker compose -f docker-compose.test.yml up -d
docker compose logs -f &

echo 'Waiting for the API to start...'
timeout=60
while true
do
  response=$(
    curl \
      --write-out '%{http_code}' \
      --silent \
      --output /dev/null \
      http://localhost:5000/health || true
  )
  if [ "$response" -eq 200 ]; then
    break
  else
    printf '.'
    sleep 1
    ((timeout=timeout-1))
    if [ "$timeout" -le 0 ]; then
      echo "Timed out waiting for API to start"
      exit 1
    fi
  fi
done

export DUO_DB_HOST=localhost
export DUO_DB_PORT=5432
export DUO_DB_USER=postgres
export DUO_DB_PASS=password

# Run tests
"$@"

docker compose kill || true
docker compose down || true
