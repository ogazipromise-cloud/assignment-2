#!/usr/bin/env bash

set -u

IMAGE_NAME="diagnostic-tool"
FAILED=0

pass() {
echo "[PASS] $1"
}

fail() {
echo "[FAIL] $1"
FAILED=1
}

echo "===== Running Diagnostic Tool Tests ====="

if docker run --rm "$IMAGE_NAME" help | grep -q "Commands:"; then
pass "Help command"
else
fail "Help command"
fi

if docker run --rm "$IMAGE_NAME" system | grep -q "System Information"; then
pass "System command"
else
fail "System command"
fi

if docker run --rm "$IMAGE_NAME" disk | grep -q "Disk Information"; then
pass "Disk command"
else
fail "Disk command"
fi

docker run --rm "$IMAGE_NAME" invalid >/dev/null 2>&1
STATUS=$?

if [[ "$STATUS" -eq 2 ]]; then
pass "Invalid command returns exit code 2"
else
fail "Invalid command handling"
fi

if [[ "$FAILED" -eq 0 ]]; then
echo "All tests passed."
exit 0
else
echo "One or more tests failed."
exit 1
fi
