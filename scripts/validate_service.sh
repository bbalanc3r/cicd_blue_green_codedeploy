#!/usr/bin/env bash
set -euo pipefail

LOG_DIR="/var/log/codedeploy"
LOG_FILE="$LOG_DIR/validate_service.log"
HEALTH_URL="http://localhost:8000/health"
MAX_ATTEMPTS=30
SLEEP_SECONDS=2

mkdir -p "$LOG_DIR"
exec > >(tee -a "$LOG_FILE") 2>&1

log() { echo "[$(date -Is)] $*"; }

log "Starting validate_service"

if ! command -v curl >/dev/null 2>&1; then
  log "curl not found; installing"
  yum -y install curl
fi

attempt=1
while [[ $attempt -le $MAX_ATTEMPTS ]]; do
  code="$(curl -sS -o /dev/null -w "%{http_code}" "$HEALTH_URL" || true)"
  if [[ "$code" == "200" ]]; then
    log "Health check OK (HTTP $code)"
    log "validate_service completed"
    exit 0
  fi

  log "Health check attempt $attempt/$MAX_ATTEMPTS failed (HTTP $code); retrying in ${SLEEP_SECONDS}s"
  sleep "$SLEEP_SECONDS"
  attempt=$((attempt + 1))
done

log "ERROR: Health check failed after $MAX_ATTEMPTS attempts"
exit 1
