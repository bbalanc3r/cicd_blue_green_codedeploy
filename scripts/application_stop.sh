#!/usr/bin/env bash
set -euo pipefail

LOG_DIR="/var/log/codedeploy"
LOG_FILE="$LOG_DIR/application_stop.log"
SERVICE_NAME="gunicorn.service"

mkdir -p "$LOG_DIR"
exec > >(tee -a "$LOG_FILE") 2>&1

log() { echo "[$(date -Is)] $*"; }

log "Starting application_stop"

if systemctl list-unit-files | awk '{print $1}' | grep -qx "$SERVICE_NAME"; then
  if systemctl is-active --quiet "$SERVICE_NAME"; then
    log "Stopping $SERVICE_NAME"
    systemctl stop "$SERVICE_NAME"
  else
    log "$SERVICE_NAME not active; nothing to stop"
  fi
else
  log "$SERVICE_NAME not installed; nothing to stop"
fi

log "application_stop completed"
