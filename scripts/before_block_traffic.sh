#!/usr/bin/env bash
set -euo pipefail

LOG_DIR="/var/log/codedeploy"
LOG_FILE="$LOG_DIR/before_block_traffic.log"
SERVICE_NAME="gunicorn.service"

mkdir -p "$LOG_DIR"
exec > >(tee -a "$LOG_FILE") 2>&1

log() { echo "[$(date -Is)] $*"; }

log "Starting before_block_traffic"

# On the old (currently serving) environment, CodeDeploy will block traffic via ALB.
# Stopping here is safe and idempotent; if the service is already down, we continue.
if systemctl list-unit-files | awk '{print $1}' | grep -qx "$SERVICE_NAME"; then
  if systemctl is-active --quiet "$SERVICE_NAME"; then
    log "Stopping $SERVICE_NAME before traffic is blocked"
    systemctl stop "$SERVICE_NAME"
  else
    log "$SERVICE_NAME not active; nothing to stop"
  fi
else
  log "$SERVICE_NAME not installed; nothing to stop"
fi

log "before_block_traffic completed"
