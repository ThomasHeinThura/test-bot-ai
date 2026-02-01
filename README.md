# OpenClaw Production Stack

Production-ready AI agent platform with monitoring, security, and observability.

## 🏗️ Architecture

- **Nginx Proxy Manager**: Reverse proxy with Let's Encrypt SSL automation (Web UI on port 81)
- **OpenClaw**: AI agent gateway with Azure OpenAI integration
- **Grafana**: Metrics visualization and dashboards
- **VictoriaMetrics**: High-performance metrics database
- **Loki**: Log aggregation system
- **Promtail**: Log collector
- **Falco**: Runtime security monitoring
- **Falcosidekick**: Security alert routing

## 🚀 Quick Start

### Prerequisites
- Docker & Docker Compose
- Domain pointing to your server IP
- Azure OpenAI API key

### Setup

1. **Clone repository**
```bash
git clone https://github.com/ThomasHeinThura/test-bot-ai.git
cd test-bot-ai
```

2. **Configure environment**
```bash
# Create .env file
cat > .env << 'EOF'
TZ=Asia/Yangon
ADMIN_USER=admin
ADMIN_PASS=your_strong_password_here
GRAFANA_USER=admin
GRAFANA_PASS=your_grafana_password_here
OPENCLAW_TOKEN=your_openclaw_token_here
AZURE_OPENAI_ENDPOINT=https://your-resource.openai.azure.com/
AZURE_OPENAI_MODEL=gpt-4
EOF

# Create secrets directory
mkdir -p /home/bimdevops/.secrets
echo "your_azure_openai_api_key" > /home/bimdevops/.secrets/openai_key
chmod 600 /home/bimdevops/.secrets/openai_key
```

3. **Start services**
```bash
docker compose up -d
```

4. **Configure Let's Encrypt SSL**
   - Open http://your-server-ip:81
   - Default login: `admin@example.com` / `changeme`
   - **Change password immediately!**
   - Go to "SSL Certificates" → "Add SSL Certificate"
   - Select "Let's Encrypt", enter your domain
   - Go to "Proxy Hosts" → "Add Proxy Host"
     - Domain: `grf.bimats.net`
     - Forward to: `grafana:3000`
     - Enable "SSL" with your certificate
     - Enable "Force SSL"

## 📊 Access

- **Nginx Proxy Manager**: http://your-ip:81 (Setup SSL certificates here)
- **Grafana**: https://grf.bimats.net (after SSL setup)
- **OpenClaw**: Internal only (backend network)

## 🔒 Security Features

- ✅ No secrets in git (using .env + .gitignore)
- ✅ Docker secrets for API keys
- ✅ No-new-privileges security option
- ✅ Dropped capabilities (least privilege)
- ✅ Runtime security monitoring with Falco
- ✅ Resource limits (CPU/memory)
- ✅ Automatic SSL/TLS with Let's Encrypt
- ✅ Health checks for all services

## 📈 Monitoring

Check service health:
```bash
docker compose ps
docker compose logs -f
```

View metrics in Grafana (https://grf.bimats.net)

## 🛠️ Maintenance

**Update services:**
```bash
docker compose pull
docker compose up -d
```

**View logs:**
```bash
docker compose logs -f [service_name]
```

**Backup data:**
```bash
# Backup volumes
docker run --rm -v openclaw-prod_grafana_data:/data -v $(pwd):/backup alpine tar czf /backup/grafana-backup.tar.gz /data
```

## ⚠️ Important Notes

1. **Never commit .env file** - contains secrets
2. **Change default passwords** immediately after first login
3. **Restrict port 81** (Nginx Proxy Manager admin) using firewall:
   ```bash
   sudo ufw allow from YOUR_IP to any port 81 proto tcp
   ```
4. **Regular backups** of Docker volumes

## 📝 License

MIT License - see LICENSE file

## 🙋 Support

For issues, please open a GitHub issue.
