#! /bin/bash
# Start the domain-server with persistant data in local dir
# Invocation: ./run-domain-server {metaverse_server_url} {ice_server_location}
#   or the metaverse-server and ice-server can be set with environment
#      variables METAVERSE_URL and ICE_SERVER

export ENV_METAVERSE_URL=${METAVERSE_URL:-https://metaverse.vircadia.com/live}
if [[ ! -z "$1" ]] ; then
    ENV_METAVERSE_URL=$1
fi
export ENV_ICE_SERVER=${ICE_SERVER:-ice.vircadia.com:7337}
if [[ ! -z "$2" ]] ; then
    ENV_ICE_SERVER=$2
fi

# There can be multiple domain-servers on one host. This is the default index
export INSTANCE=0

# Get the directory that this script is running from
BASE="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd )"

# Create a cleaned up version of the METAVERSE_URL to use as directory for per-grid info
CLEANMVNAME=$(echo $ENV_METAVERSE_URL | sed -e 's=http.*://==' -e 's/[[:punct:]]/./g')

# Grid configuration and info stored here
DOTLOCALDIR=${BASE}/server-dotlocal/${CLEANMVNAME}
LOGDIR=${BASE}/server-logs/${CLEANMVNAME}/$INSTANCE

# Debugging stuff that can be removed
echo "METAVERSE_URL=${ENV_METAVERSE_URL}"
echo "ICE_SERVER=${ENV_ICE_SERVER}"
echo "CLEANMVNAME=${CLEANMVNAME}"
echo "DOTLOCALDIR=${DOTLOCALDIR}"
echo "LOGDIR=${LOGDIR}"

cd "${BASE}"

DVERSION=latest

# Create local directories that are mounted from the Docker container
# Permission is set to 777 since the container runs its own UID:GID
mkdir -p "${DOTLOCALDIR}"
chmod 777 "${DOTLOCALDIR}"
mkdir -p "${LOGDIR}"
chmod 777 "${LOGDIR}"

docker run \
        -d \
        --restart=unless-stopped \
        --name=domainserver \
        -e METAVERSE_URL=$ENV_METAVERSE_URL \
        -e ICE_SERVER=$ENV_ICE_SERVER \
        -e INSTANCE=$INSTANCE \
        --network=host \
        --volume ${DOTLOCALDIR}:/home/cadia/.local \
        --volume ${LOGDIR}:/home/cadia/logs \
        misterblue/vircadia-domain-server:${DVERSION}

# The assignment clients are all over the place so network=host works
#        -p 40100-40102:40100-40102 -p 40100-40102:40100-40102/udp \
#        -p 48000-48009:48000-48009/udp \
