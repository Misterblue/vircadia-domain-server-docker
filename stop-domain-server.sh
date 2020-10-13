#! /bin/bash
# Stops the domain server and cleans up

echo "==== stopping domain-server"
docker stop domainserver
echo "==== removing old domain-server image"
docker rm domainserver
