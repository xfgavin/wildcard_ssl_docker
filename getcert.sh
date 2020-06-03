#!/usr/bin/env bash
DOCKER=`which docker`
[ ${#DOCKER} -eq 0 ] && echo "ERROR: docker not found, please install it first." && exit -1
COMPOSER=`which docker-compose`
[ ${#COMPOSER} -eq 0 ] && echo "ERROR: docker-compose not found, please install it first." && exit -1
SCRIPTROOT=$( cd $(dirname $0) ; pwd)
cd $SCRIPTROOT
mkdir -p etc
mkdir -p lib
mkdir -p log
if [ ! -f etc/cloudflare.ini -o ! -f docker-compose.yml ]
then
  while [ "$email" = "" ]
  do
    echo -n "Email address? "
    read email
  done
  while [ "$domain" = "" ]
  do
    echo -n "Your domain?"
    read domain
  done
  while [ "$apitoken" = "" ]
  do
    echo -n "cloudflare API token of your domain? "
    read apitoken
  done
cat << APIKEY > etc/cloudflare.ini
# Cloudflare API credentials used by Certbot
dns_cloudflare_api_token = $apitoken
APIKEY

cat << CONFIG > docker-compose.yml
version: '2'
services:
   ssl:
      image: certbot/dns-cloudflare:arm32v6-latest
      volumes:
        - $SCRIPTROOT/etc:/etc/letsencrypt:rw
        - $SCRIPTROOT/lib:/var/lib/letsencrypt:rw
        - $SCRIPTROOT/log:/var/log/letsencrypt:rw
      command: "certonly --agree-tos -m $email --non-interactive --manual-public-ip-logging-ok --expand --dns-cloudflare --dns-cloudflare-credentials /etc/letsencrypt/cloudflare.ini --dns-cloudflare-propagation-seconds 30 --server https://acme-v02.api.letsencrypt.org/directory -d *.$domain"
CONFIG
fi
$COMPOSER -p ssl up
