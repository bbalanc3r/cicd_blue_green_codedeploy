#!/usr/bin/env bash
set -euo pipefail

systemctl stop gunicorn.service 2>/dev/null || true