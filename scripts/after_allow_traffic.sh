#!/usr/bin/env bash
set -euo pipefail

LOG_DIR="/var/log/codedeploy"
LOG_FILE="$LOG_DIR/after_allow_traffic.log"

mkdir -p "$LOG_DIR"
exec > >(tee -a "$LOG_FILE") 2>&1

log() { echo "[$(date -Is)] $*"; }

log "Starting after_allow_traffic"

# Post-cutover validation: confirm the instance serving traffic is still healthy.
if [[ -x "/var/www/app/scripts/validate_service.sh" ]]; then
  /var/www/app/scripts/validate_service.sh
else
  if [[ -x "./scripts/validate_service.sh" ]]; then
    ./scripts/validate_service.sh
  else
    log "ERROR: validate_service.sh not found"
    exit 1
  fi
fi

log "after_allow_traffic completed"
