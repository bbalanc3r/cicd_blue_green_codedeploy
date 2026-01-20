#!/usr/bin/env bash
set -euo pipefail

LOG_DIR="/var/log/codedeploy"
LOG_FILE="$LOG_DIR/install_dependencies.log"
APP_DIR="/var/www/app"
VENV_DIR="$APP_DIR/venv"
RUN_USER="ec2-user"

mkdir -p "$LOG_DIR"
exec > >(tee -a "$LOG_FILE") 2>&1

log() { echo "[$(date -Is)] $*"; }

log "Starting install_dependencies"

if ! command -v python3 >/dev/null 2>&1; then
  log "python3 not found; installing"
  yum -y install python3
fi

log "Ensuring venv tooling is available"
python3 -m ensurepip --upgrade || true

if [[ ! -d "$VENV_DIR" ]]; then
  log "Creating virtualenv at $VENV_DIR"
  mkdir -p "$APP_DIR"
  python3 -m venv "$VENV_DIR"
  chown -R "$RUN_USER:$RUN_USER" "$VENV_DIR"
else
  log "Virtualenv already exists at $VENV_DIR"
fi

if [[ ! -f "$APP_DIR/requirements.txt" ]]; then
  log "ERROR: requirements.txt not found at $APP_DIR/requirements.txt"
  exit 1
fi

log "Upgrading pip/setuptools/wheel"
"$VENV_DIR/bin/python" -m pip install --upgrade pip setuptools wheel

log "Installing Python dependencies from requirements.txt"
"$VENV_DIR/bin/python" -m pip install --no-cache-dir -r "$APP_DIR/requirements.txt"

log "Ensuring app directory ownership -> $RUN_USER"
chown -R "$RUN_USER:$RUN_USER" "$APP_DIR"

log "install_dependencies completed"
