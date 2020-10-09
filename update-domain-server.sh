#! /bin/bash
# Pulls the latest image and restarts the domain-server with newest image

echo "==== fetching latest docker image for domain-server"
docker pull misterblue/vircadia-domain-server
echo "==== stopping domain-server"
docker stop domainserver
echo "==== removing old domain-server image"
docker rm domainserver
echo "==== starting domain-server"
./run-domain-server.sh

