#!/usr/bin/env bash
set -euo pipefail

LOG_DIR="/var/log/codedeploy"
LOG_FILE="$LOG_DIR/before_install.log"
APP_DIR="/var/www/app"
SERVICE_NAME="gunicorn.service"

mkdir -p "$LOG_DIR"
exec > >(tee -a "$LOG_FILE") 2>&1

log() { echo "[$(date -Is)] $*"; }

log "Starting before_install"

systemctl stop "$SERVICE_NAME" 2>/dev/null || true
mkdir -p "$APP_DIR"
chown -R ec2-user:ec2-user "$APP_DIR"

log "before_install completed"