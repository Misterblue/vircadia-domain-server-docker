#! /bin/bash
# Start the ice-server with persistant data in local dir
# Invocation: ./run-ice-server {metaverse_server_url}
#    or the metaverse url can be set with environment variable METAVERSE_URL

export ENV_METAVERSE_URL=${METAVERSE_URL:-https://metaverse.vircadia.com/live}
if [[ ! -z "$1" ]] ; then
    ENV_METAVERSE_URL=$1
fi

# Get the directory that this script is running from
BASE="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd )"

# Create a cleaned up version of the METAVERSE_URL to use as directory for per-grid info
CLEANMVNAME=$(echo $ENV_METAVERSE_URL | sed -e 's=http.*://==' -e 's/[[:punct:]]/./g')

DOTLOCALDIR=${BASE}/server-dotlocal/${CLEANMVNAME}
LOGDIR=${BASE}/server-logs/${CLEANMVNAME}

DVERSION=latest

# Debugging stuff that can be removed
echo "METAVERSE_URL=${ENV_METAVERSE_URL}"
echo "DOTLOCALDIR=${DOTLOCALDIR}"
echo "LOGDIR=${LOGDIR}"
echo "DVERSION=${DVERSION}"

cd "${BASE}"

# Create local directories that are mounted from the Docker container
# Permission is set to 777 since the container runs its own UID:GID
mkdir -p ${DOTLOCALDIR}
chmod 777 ${DOTLOCALDIR}
mkdir -p ${LOGDIR}
chmod 777 ${LOGDIR}

docker run \
        -d \
        --restart=unless-stopped \
        --name=iceserver \
        -p 7337:7337 \
        -p 7337:7337/udp \
        -e METAVERSE_URL=$ENV_METAVERSE_URL \
        --volume ${LOGDIR}:/home/cadia/logs \
        --entrypoint /home/cadia/start-ice-server.sh \
        misterblue/vircadia-domain-server:${DVERSION}
