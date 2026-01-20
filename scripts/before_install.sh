#!/usr/bin/env bash
set -euo pipefail

LOG_DIR="/var/log/codedeploy"
LOG_FILE="$LOG_DIR/before_install.log"
APP_DIR="/var/www/app"
SERVICE_NAME="gunicorn.service"
RUN_USER="ec2-user"

mkdir -p "$LOG_DIR"
exec > >(tee -a "$LOG_FILE") 2>&1

log() { echo "[$(date -Is)] $*"; }

log "Starting before_install"

if systemctl list-unit-files | awk '{print $1}' | grep -qx "$SERVICE_NAME"; then
  if systemctl is-active --quiet "$SERVICE_NAME"; then
    log "Stopping existing $SERVICE_NAME"
    systemctl stop "$SERVICE_NAME"
  else
    log "$SERVICE_NAME not active; nothing to stop"
  fi
else
  log "$SERVICE_NAME not installed yet; skipping stop"
fi

if [[ ! -d "$APP_DIR" ]]; then
  log "Creating application directory $APP_DIR"
  mkdir -p "$APP_DIR"
fi

log "Ensuring ownership of $APP_DIR -> $RUN_USER"
chown -R "$RUN_USER:$RUN_USER" "$APP_DIR"

log "before_install completed"
