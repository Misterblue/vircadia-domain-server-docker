#! /bin/bash
# Build the domain-server Docker image based on the base image.
# Invocation: ./buildDS.sh {GIT-tag-to-pull}

export BUILDREPO=${VIRCADIA_REPO:-https://github.com/vircadia/vircadia}

# if the env variable exists and no parameter specified, use that
if [[ ! -z "$VIRCADIA_TAG" && -z "$1" ]] ; then
    ATAG=$VIRCADIA_TAG
else
    ATAG=${1:-master}
fi

#NOCACHE=--no-cache

# vircadia-builder normalizes the tag name with all special chars to underscore
export BUILDTAG=$(echo $ATAG | sed -e 's/[[:punct:]]/_/g')

echo "Building Vircadia domain server ${BUILDREPO}:${BUILDTAG}"

docker build -f Dockerfile-ds \
    --build-arg REPO=${BUILDREPO} \
    --build-arg TAG=${BUILDTAG} \
    ${NOCACHE} \
    -t vircadia-domain-server . | tee out.buildDS 2>&1
