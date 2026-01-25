#!/usr/bin/env bash
set -euo pipefail

LOG_DIR="/var/log/codedeploy"
LOG_FILE="$LOG_DIR/install_dependencies.log"
APP_DIR="/var/www/app"
VENV_DIR="$APP_DIR/venv"

mkdir -p "$LOG_DIR"
exec > >(tee -a "$LOG_FILE") 2>&1

log() { echo "[$(date -Is)] $*"; }

log "Starting install_dependencies"

python3 -m venv "$VENV_DIR"
"$VENV_DIR/bin/pip" install --upgrade pip
"$VENV_DIR/bin/pip" install -r "$APP_DIR/requirements.txt"
chown -R ec2-user:ec2-user "$APP_DIR"

log "install_dependencies completed"