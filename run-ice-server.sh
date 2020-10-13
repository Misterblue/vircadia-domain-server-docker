#! /bin/bash
# Start the ice-server with persistant data in local dir
# Invocation: ./run-ice-server {metaverse_server_url}

export ENV_METAVERSE_URL=${1:-https://metaverse.vircadia.com/live}

BASE="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd )"

cd "${BASE}"

DVERSION=latest

# Create local directories that are mounted from the Docker container
# Permission is set to 777 since the container runs its own UID:GID
mkdir -p ${BASE}/server-dotlocal
chmod 777 ${BASE}/server-dotlocal
mkdir -p ${BASE}/server-logs
chmod 777 ${BASE}/server-logs

docker run \
        -d \
        --restart=unless-stopped \
        --name=iceserver \
        -p 7337:7337 \
        -e METAVERSE_URL=$ENV_METAVERSE_URL \
        --volume ${BASE}/server-logs:/home/cadia/logs \
        --entrypoint /home/cadia/start-ice-server.sh \
        misterblue/vircadia-domain-server:${DVERSION}
