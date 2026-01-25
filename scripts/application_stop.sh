#!/usr/bin/env bash
set -euo pipefail

LOG_DIR="/var/log/codedeploy"
LOG_FILE="$LOG_DIR/application_stop.log"
SERVICE_NAME="gunicorn.service"

mkdir -p "$LOG_DIR"
exec > >(tee -a "$LOG_FILE") 2>&1

log() { echo "[$(date -Is)] $*"; }

log "Starting application_stop"

systemctl stop "$SERVICE_NAME" 2>/dev/null || true

log "application_stop completed"