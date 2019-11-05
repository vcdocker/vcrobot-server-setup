#!/bin/sh

curl -sL https://raw.githubusercontent.com/vcdocker/vcrobot-server-setup/master/install/docker/${docker_version_agent}.sh | sh

mkdir ~/.vcrobot && cd ~/.vcrobot

curl -L https://github.com/vcdocker/docker-traefik/archive/2.0.zip | tar -xzk --strip-components=1 -C $(pwd)

docker swarm init
docker network create --driver=overlay --attachable vcrobot

export PORTAINER_DOMAIN=portainer.domain.com
export ACME_EMAIL=dev@vicoders.com
export TRAEFIK_DEBUGE=true
export ENABLE_TRAEFIK_API=true
export ENABLE_TRAEFIK_API_DASHBOARD=true
export ENABLE_TRAEFIK_API_INSECURE=true
export ENABLE_TRAEFIK_CERT_RESOLVER=staging
export ENABLE_TRAEFIK_ACCESS_LOG=true

touch letsencrypt/acme.json && chmod 600 letsencrypt/acme.json
touch logs/access.log

docker stack deploy -c docker-compose.yaml vcrobot