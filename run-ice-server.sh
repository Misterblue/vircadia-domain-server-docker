#! /bin/bash
# Start the ice-server with persistant data in local dir
# Invocation: ./run-ice-server {metaverse_server_url}
#    or the metaverse url can be set with environment variable METAVERSE_URL
# This uses several environment variables for various options:
#    METAVERSE_URL: URL to metaverse-server (default = https://metaverse.vircadia.com/live)
#    ICE_SERVER: URL to the ICE server (default = "ice.vircadia.com:7337")
#    DOCKER_REPOSITORY: name of repository to fetch image (default = "misterblue")
#         if DOCKER_REPOSITORY === "LOCAL" then the local image repository is used
#    IMAGE_NAME: name of docker image to run (default = "vircadia-domain-server")
#    IMAGE_VERSION: version of docker image to use (default = "latest")
# With no changes, this runs the Docker image "misterblue/vircadia-domain-server:latest"
#    pointing to the metaverse-server at "https://metaverse.vircadia.com/live"
#    and run as ICE server "ice.vircadia.com:7337"..

export METAVERSE_URL=${METAVERSE_URL:-https://metaverse.vircadia.com/live}
if [[ ! -z "$1" ]] ; then
    METAVERSE_URL=$1
fi

export DOCKER_REPOSITORY=${DOCKER_REPOSITORY:-misterblue}
export IMAGE_NAME=${IMAGE_NAME:-vircadia-domain-server}
export IMAGE_VERSION=${IMAGE_VERSION:-latest}
if [[ "${DOCKER_REPOSITORY}" == "LOCAL" ]] ; then
    export DOCKER_IMAGE=${IMAGE_NAME}:${IMAGE_VERSION}
else
    export DOCKER_IMAGE=${DOCKER_REPOSITORY}/${IMAGE_NAME}:${IMAGE_VERSION}
fi

# Get the directory that this script is running from
BASE="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd )"

# Create a cleaned up version of the METAVERSE_URL to use as directory for per-grid info
CLEANMVNAME=$(echo $METAVERSE_URL | sed -e 's=http.*://==' -e 's/[[:punct:]]/./g')

DOTLOCALDIR=${BASE}/server-dotlocal/${CLEANMVNAME}
LOGDIR=${BASE}/server-logs/${CLEANMVNAME}

DVERSION=latest

# Debugging stuff that can be removed
echo "METAVERSE_URL=${METAVERSE_URL}"
echo "DOTLOCALDIR=${DOTLOCALDIR}"
echo "LOGDIR=${LOGDIR}"
echo "DOCKER_IMAGE=${DOCKER_IMAGE}"

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
        -e METAVERSE_URL=$METAVERSE_URL \
        --volume ${LOGDIR}:/home/cadia/logs \
        --entrypoint /home/cadia/start-ice-server.sh \
        ${DOCKER_IMAGE}
