#!/usr/bin/env bash
# DEPRECATED: use Docker. This wrapper redirects to scripts/docker/setup.sh
echo "NOTE: Host PHP install is deprecated. Prefer Docker:"
echo "  AUTO_INSTALL=1 PROJECT_DIR=. bash \"$(dirname "$0")/docker/setup.sh\""
echo "Native php -S is only for when the user explicitly opts out of Docker."
if [ "${FORCE_NATIVE:-0}" = "1" ]; then
  echo "FORCE_NATIVE=1 set — refusing automated native install in v1.2; use docker/setup.sh or ask the user."
  exit 1
fi
exec bash "$(dirname "$0")/docker/setup.sh" "$@"
