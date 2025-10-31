#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

echo "> Building server..."
swift build -v

echo "> Running migrations..."
swift run Run migrate

echo "> Starting server on http://localhost:8080 ..."
swift run Run serve


