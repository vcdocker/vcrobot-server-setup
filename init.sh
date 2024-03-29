#!/bin/sh

# curl -sL https://raw.githubusercontent.com/vcdocker/vcrobot-server-setup/master/install/docker/19.03.sh | sh

mkdir ~/.vcrobot && cd ~/.vcrobot

curl -L https://github.com/vcdocker/docker-traefik/archive/2.0.0.tar.gz | tar -xzk --strip-components=1 -C $(pwd)

docker swarm init
docker network create --driver=overlay --attachable vcrobot

sudo apt install apache2-utils -y

echo 'export VC_USER={{user}}' >> ~/.bashrc && export VC_USER={{user}}
echo 'export VC_PASSWORD={{password}}' >> ~/.bashrc && export VC_PASSWORD={{password}}
echo 'export VC_BASIC_AUTH=$(htpasswd -nb $VC_USER $VC_PASSWORD)' >> ~/.bashrc && export VC_BASIC_AUTH=$(htpasswd -nb $VC_USER $VC_PASSWORD)
echo 'export ACME_EMAIL={{acme_email}}' >> ~/.bashrc && export ACME_EMAIL={{acme_email}}
echo 'export TRAEFIK_DEBUGE=true' >> ~/.bashrc && export TRAEFIK_DEBUGE=true
echo 'export ENABLE_TRAEFIK_API=true' >> ~/.bashrc && export ENABLE_TRAEFIK_API=true
echo 'export ENABLE_TRAEFIK_API_DASHBOARD=true' >> ~/.bashrc && export ENABLE_TRAEFIK_API_DASHBOARD=true
echo 'export ENABLE_TRAEFIK_CERT_RESOLVER={{cert_resolver}}' >> ~/.bashrc && export ENABLE_TRAEFIK_CERT_RESOLVER={{cert_resolver}}
echo 'export ENABLE_TRAEFIK_ACCESS_LOG=false' >> ~/.bashrc && export ENABLE_TRAEFIK_ACCESS_LOG=false

touch letsencrypt/acme.json && chmod 600 letsencrypt/acme.json
touch logs/access.log

docker stack deploy -c docker-compose.yaml vcrobot