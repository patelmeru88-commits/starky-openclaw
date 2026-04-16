#!/bin/bash
set -e

echo "=== STARKY OPENCLAW STARTUP ==="
echo "PORT: $PORT"
echo "OPENCLAW_GATEWAY_TOKEN: $OPENCLAW_GATEWAY_TOKEN"
echo "TELEGRAM_BOT_TOKEN set: $([ -n "$TELEGRAM_BOT_TOKEN" ] && echo yes || echo no)"
echo "GEMINI_API_KEY set: $([ -n "$GEMINI_API_KEY" ] && echo yes || echo no)"

# Start OpenClaw gateway on internal port 3000 in background
echo "=== Starting OpenClaw gateway on port 3000 ==="
openclaw gateway --port 3000 --allow-unconfigured &
OPENCLAW_PID=$!
echo "OpenClaw PID: $OPENCLAW_PID"

# Wait for OpenClaw to bind
echo "=== Waiting 5s for OpenClaw to start ==="
sleep 5

# Show what's listening
echo "=== Listening ports ==="
netstat -tlnp 2>/dev/null || ss -tlnp

# Verify OpenClaw is actually listening on 3000
if netstat -tlnp 2>/dev/null | grep -q ':3000' || ss -tlnp | grep -q ':3000'; then
echo "=== OpenClaw confirmed on port 3000 ==="
else
echo "=== WARNING: Nothing on port 3000, OpenClaw may have failed ==="
fi

# Start socat proxy: forward 0.0.0.0:$PORT -> 127.0.0.1:3000
echo "=== Starting socat proxy: 0.0.0.0:$PORT -> 127.0.0.1:3000 ==="
exec socat TCP-LISTEN:${PORT},fork,reuseaddr TCP:127.0.0.1:3000
