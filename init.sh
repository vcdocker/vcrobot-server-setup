#!/bin/sh

# curl -sL https://raw.githubusercontent.com/vcdocker/vcrobot-server-setup/master/install/docker/19.03.sh | sh

mkdir ~/.vcrobot && cd ~/.vcrobot

curl -L https://github.com/vcdocker/docker-traefik/archive/2.0.0.tar.gz | tar -xzk --strip-components=1 -C $(pwd)

docker swarm init
docker network create --driver=overlay --attachable vcrobot

echo 'export VC_USER=admin' >> ~/.bash_profile && export VC_USER=admin
echo 'export VC_PASSWORD=secret' >> ~/.bash_profile && export VC_PASSWORD=secret
echo 'export VC_BASIC_AUTH=$(htpasswd -nb $VC_USER $VC_PASSWORD)' >> ~/.bash_profile && export VC_BASIC_AUTH=$(htpasswd -nb $VC_USER $VC_PASSWORD)
echo 'export ACME_EMAIL=dev@vicoders.com' >> ~/.bash_profile && export ACME_EMAIL=dev@vicoders.com
echo 'export TRAEFIK_DEBUGE=true' >> ~/.bash_profile && export TRAEFIK_DEBUGE=true
echo 'export ENABLE_TRAEFIK_API=true' >> ~/.bash_profile && export ENABLE_TRAEFIK_API=true
echo 'export ENABLE_TRAEFIK_API_DASHBOARD=true' >> ~/.bash_profile && export ENABLE_TRAEFIK_API_DASHBOARD=true
echo 'export ENABLE_TRAEFIK_CERT_RESOLVER=staging' >> ~/.bash_profile && export ENABLE_TRAEFIK_CERT_RESOLVER=staging
echo 'export ENABLE_TRAEFIK_ACCESS_LOG=true' >> ~/.bash_profile && export ENABLE_TRAEFIK_ACCESS_LOG=true

touch letsencrypt/acme.json && chmod 600 letsencrypt/acme.json
touch logs/access.log

docker stack deploy -c docker-compose.yaml vcrobot