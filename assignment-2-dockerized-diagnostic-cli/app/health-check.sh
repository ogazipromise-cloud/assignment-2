#!/usr/bin/env bash

set -u

APP="/app/diagnostic.sh"

if [[ ! -x "$APP" ]]; then
echo "Health check failed: diagnostic application is missing or not executable." >&2
exit 1
fi

if "$APP" help >/dev/null 2>&1; then
echo "Health check passed."
exit 0
else
echo "Health check failed." >&2
exit 1
fi
