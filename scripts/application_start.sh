#!/usr/bin/env bash
set -euo pipefail

LOG_DIR="/var/log/codedeploy"
LOG_FILE="$LOG_DIR/application_start.log"
SERVICE_NAME="gunicorn.service"

mkdir -p "$LOG_DIR"
exec > >(tee -a "$LOG_FILE") 2>&1

log() { echo "[$(date -Is)] $*"; }

log "Starting application_start"

systemctl daemon-reload
systemctl enable "$SERVICE_NAME"
systemctl restart "$SERVICE_NAME"

log "application_start completed"