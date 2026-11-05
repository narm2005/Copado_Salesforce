#!/usr/bin/env bash
# Usage: ./run.sh            -> all tests
#        ./run.sh smoke      -> only tests tagged smoke
set -euo pipefail
cd "$(dirname "$0")"
if [ -f .env ]; then set -a; source .env; set +a; fi
TAG="${1:-}"
if [ -n "$TAG" ]; then
  robot --outputdir results --include "$TAG" tests/
else
  robot --outputdir results tests/
fi
