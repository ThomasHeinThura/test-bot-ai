#!/bin/bash
# OpenClaw WhatsApp Quick Setup Script

set -e

echo "🚀 OpenClaw WhatsApp Setup"
echo "=========================="
echo ""

# Get server IP
SERVER_IP=$(curl -s -4 ifconfig.me)
echo "✅ Server IP: $SERVER_IP"
echo ""

# Check OpenClaw status
echo "📊 Checking services..."
cd /home/bimdevops/openclaw-prod
docker compose ps openclaw | grep openclaw

echo ""
echo "✅ OpenClaw is running!"
echo ""

# Get token
TOKEN=$(grep OPENCLAW_TOKEN .env | cut -d= -f2)
echo "🔑 Your OpenClaw Token: $TOKEN"
echo ""

# Dashboard URL
echo "🌐 Dashboard Access:"
echo "   http://$SERVER_IP:18789"
echo "   or"
echo "   http://localhost:18789  (if on the server)"
echo ""

echo "📱 WhatsApp Connection Steps:"
echo ""
echo "Option 1: Via Dashboard (Recommended)"
echo "  1. Open: http://$SERVER_IP:18789"
echo "  2. Paste token: $TOKEN"
echo "  3. Go to Channels → WhatsApp"
echo "  4. Click 'Connect' and scan QR code"
echo ""
echo "Option 2: Via CLI"
echo "  Run: docker compose exec openclaw node dist/index.js channels login"
echo "  Then scan the QR code with WhatsApp"
echo ""

echo "⚠️  IMPORTANT: After connecting, configure allowed phone numbers!"
echo "   Edit: config/openclaw/openclaw.json"
echo "   Add your numbers to 'channels.whatsapp.allowFrom'"
echo ""

echo "🔥 Quick Commands:"
echo "   Status: docker compose ps"
echo "   Logs: docker compose logs openclaw -f"
echo "   Restart: docker compose restart openclaw"
echo ""
