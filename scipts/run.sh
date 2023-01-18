#!/usr/bin/env bash

set -e

edgedb migrate --dsn="${DATABASE_URL}" --tls-security="${EDGEDB_TLS_SECURITY}" || true

python -m app
