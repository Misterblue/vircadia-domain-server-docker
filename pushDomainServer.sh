#! /bin/bash

REPO=misterblue/vircadia-domain-server

IMAGE=vircadia-domain-server

VERSIONLABEL=$(docker run --rm --entrypoint /home/cadia/getVersion.sh vircadia-domain-server VERSION_TAG)

echo "Pushing docker image for domain-server version ${VERSIONLABEL}"

for tagg in ${VERSIONLABEL} latest ; do
    docker tag ${IMAGE} ${REPO}:${tagg}
    echo "   Pushing ${REPO}:${tagg}"
    docker push ${REPO}:${tagg}
done
