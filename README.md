# wildcard_ssl_docker
Let's encrypt wildcard certificate via certbot docker on raspberry Pi

## Prerequisite:
1. docker
2. docker-compose
3. API token of your domain on Cloudflare, unfortunately, due to Cloudflare's restriction, this token must have following permissions FOR ALL ZONES:
   * read permission for Zone.Zone
   * edit permission for Zone.DNS
