# SSL/HTTPS Setup Guide

## Step 1: Access Nginx Proxy Manager

1. Open your browser: **http://20.205.184.19:81**
2. Default login credentials:
   - Email: `admin@example.com`
   - Password: `changeme`
3. **⚠️ IMPORTANT**: Change password immediately after first login!

## Step 2: Setup Let's Encrypt SSL Certificate

1. Click **"SSL Certificates"** in the menu
2. Click **"Add SSL Certificate"**
3. Select **"Let's Encrypt"** tab
4. Fill in:
   - **Domain Names**: `grf.bimats.net`
   - **Email**: `admin@bimats.net` (for Let's Encrypt notifications)
   - Check **"I Agree to the Let's Encrypt Terms of Service"**
5. Click **"Save"**

Wait 10-30 seconds for certificate generation. You should see a green checkmark.

## Step 3: Create Proxy Host for Grafana

1. Click **"Proxy Hosts"** in the menu
2. Click **"Add Proxy Host"**
3. **Details** tab:
   - **Domain Names**: `grf.bimats.net`
   - **Scheme**: `http`
   - **Forward Hostname/IP**: `grafana`
   - **Forward Port**: `3000`
   - Check **"Block Common Exploits"**
   - Check **"Websockets Support"**

4. **SSL** tab:
   - **SSL Certificate**: Select the `grf.bimats.net` certificate you created
   - Check **"Force SSL"**
   - Check **"HTTP/2 Support"**
   - Check **"HSTS Enabled"**

5. Click **"Save"**

## Step 4: Test HTTPS Access

Open https://grf.bimats.net in your browser

You should see:
1. ✅ Green padlock (valid SSL certificate)
2. ✅ Grafana login page
3. Login with credentials from your `.env` file

## Security Recommendations

### 1. Restrict Nginx Proxy Manager Admin Port

```bash
# Only allow your IP to access port 81
sudo ufw allow from YOUR_HOME_IP to any port 81 proto tcp
sudo ufw deny 81
```

### 2. Add Additional Security Headers

In Nginx Proxy Manager:
- Edit your proxy host
- Go to **"Advanced"** tab
- Add:

```nginx
# Security Headers
add_header X-Frame-Options "SAMEORIGIN" always;
add_header X-Content-Type-Options "nosniff" always;
add_header X-XSS-Protection "1; mode=block" always;
add_header Referrer-Policy "no-referrer-when-downgrade" always;

# Rate Limiting
limit_req_zone $binary_remote_addr zone=grafana_limit:10m rate=10r/s;
limit_req zone=grafana_limit burst=20 nodelay;
```

### 3. Enable Access Lists (Optional)

For IP whitelisting:
1. Go to **"Access Lists"**
2. Create a new list with your trusted IPs
3. Apply it to your proxy host

## Troubleshooting

### Certificate Generation Failed

**Error**: "Could not validate ownership of domain"

**Fix**:
1. Verify DNS is correct: `dig grf.bimats.net`
2. Ensure ports 80 and 443 are open in firewall
3. Check container logs: `docker compose logs nginx-proxy-manager`

### 502 Bad Gateway

**Error**: Cannot reach Grafana

**Fix**:
1. Check Grafana is running: `docker compose ps grafana`
2. Test internal connection: `docker compose exec nginx-proxy-manager curl http://grafana:3000`

### SSL Certificate Renewal

Certificates auto-renew 30 days before expiration. Check renewal logs:
```bash
docker compose logs nginx-proxy-manager | grep -i "renew\|certificate"
```

## Advanced: Add More Domains

To add OpenClaw later:

1. Update DNS: `openclaw.bimats.net → 20.205.184.19`
2. Get SSL certificate for `openclaw.bimats.net`
3. Create proxy host:
   - Domain: `openclaw.bimats.net`
   - Forward to: `openclaw:18789`
   - Enable SSL with Force SSL

## Next Steps

✅ SSL configured → Access https://grf.bimats.net  
✅ Import Grafana dashboards  
✅ Configure OpenClaw WhatsApp integration  
✅ Setup alerts in Grafana

---

**Support**: If you encounter issues, check logs with `docker compose logs -f`
