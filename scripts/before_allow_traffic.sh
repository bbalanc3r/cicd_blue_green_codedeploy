#!/usr/bin/env bash
set -euo pipefail

LOG_DIR="/var/log/codedeploy"
LOG_FILE="$LOG_DIR/before_allow_traffic.log"

mkdir -p "$LOG_DIR"
exec > >(tee -a "$LOG_FILE") 2>&1

log() { echo "[$(date -Is)] $*"; }

log "Starting before_allow_traffic"

# Ensure the new revision is actually healthy before CodeDeploy shifts ALB traffic.
if [[ -x "/var/www/app/scripts/validate_service.sh" ]]; then
  /var/www/app/scripts/validate_service.sh
else
  # Fallback for cases where scripts run from the deployment archive working dir.
  if [[ -x "./scripts/validate_service.sh" ]]; then
    ./scripts/validate_service.sh
  else
    log "ERROR: validate_service.sh not found"
    exit 1
  fi
fi

log "before_allow_traffic completed"
