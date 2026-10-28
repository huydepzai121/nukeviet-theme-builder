#!/usr/bin/env bash
# Entry: run from Claude / user. Usage: PROJECT_DIR=./my-site scripts/nv-docker.sh
# Or: scripts/nv-docker.sh /path/to/project
set -euo pipefail
HERE=$(cd "$(dirname "$0")" && pwd)
export PROJECT_DIR=${1:-${PROJECT_DIR:-.}}
export AUTO_INSTALL=${AUTO_INSTALL:-0}
exec bash "$HERE/docker/setup.sh"
