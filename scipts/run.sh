#!/usr/bin/env bash

set -e

edgedb migrate --quiet --dsn="${DATABASE_URL}" --tls-security="${EDGEDB_TLS_SECURITY}"

python -m app
