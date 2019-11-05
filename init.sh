#!/bin/sh

# curl -sL https://raw.githubusercontent.com/vcdocker/vcrobot-server-setup/master/install/docker/19.03.sh | sh

mkdir ~/.vcrobot && cd ~/.vcrobot

curl -L https://github.com/vcdocker/docker-traefik/archive/2.0.0.tar.gz | tar -xzk --strip-components=1 -C $(pwd)

docker swarm init
docker network create --driver=overlay --attachable vcrobot

echo 'export VC_USER=admin' >> ~/.bashrc && export VC_USER=admin
echo 'export VC_PASSWORD=secret' >> ~/.bashrc && export VC_PASSWORD=secret
echo 'export VC_BASIC_AUTH=$(htpasswd -nb $VC_USER $VC_PASSWORD)' >> ~/.bashrc && export VC_BASIC_AUTH=$(htpasswd -nb $VC_USER $VC_PASSWORD)
echo 'export ACME_EMAIL=dev@vicoders.com' >> ~/.bashrc && export ACME_EMAIL=dev@vicoders.com
echo 'export TRAEFIK_DEBUGE=true' >> ~/.bashrc && export TRAEFIK_DEBUGE=true
echo 'export ENABLE_TRAEFIK_API=true' >> ~/.bashrc && export ENABLE_TRAEFIK_API=true
echo 'export ENABLE_TRAEFIK_API_DASHBOARD=true' >> ~/.bashrc && export ENABLE_TRAEFIK_API_DASHBOARD=true
echo 'export ENABLE_TRAEFIK_CERT_RESOLVER=staging' >> ~/.bashrc && export ENABLE_TRAEFIK_CERT_RESOLVER=staging
echo 'export ENABLE_TRAEFIK_ACCESS_LOG=true' >> ~/.bashrc && export ENABLE_TRAEFIK_ACCESS_LOG=true

touch letsencrypt/acme.json && chmod 600 letsencrypt/acme.json
touch logs/access.log

docker stack deploy -c docker-compose.yaml vcrobot