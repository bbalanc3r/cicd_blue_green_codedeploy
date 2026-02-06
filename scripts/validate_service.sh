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

# log "Starting health check"

# for attempt in $(seq 1 $MAX_ATTEMPTS); do
#   code=$(curl -sS -o /dev/null -w "%{http_code}" "$HEALTH_URL" 2>/dev/null || echo "000")
#   if [[ "$code" == "200" ]]; then
#     log "Health check OK (HTTP $code)"
#     exit 0
#   fi
#   log "Attempt $attempt/$MAX_ATTEMPTS failed (HTTP $code); retrying in ${SLEEP_SECONDS}s"
#   sleep "$SLEEP_SECONDS"
# done

# log "ERROR: Health check failed after $MAX_ATTEMPTS attempts"
# exit 1