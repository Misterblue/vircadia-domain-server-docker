#! /bin/bash
# Stops the ICE server and cleans up

echo "==== stopping ice-server"
docker stop iceserver
echo "==== removing old ice-server image"
docker rm iceserver
