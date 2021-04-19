# vircadia-domain-server-docker

Docker version of Vircadia domain-server built with vircadia-builder.

This repository includes files to build the Docker image (build*.sh)
and run the Docker image (*-domain-server.sh).

The Dockerfile is broken into two halves to make building and
debugging a little easier. `buildBase.sh` builds an image that
contains all the required libraries and package (Qt, ...).
`buildDS.sh` uses the base image to pull the Vircadia sources
and just build Vircadia.
This makes testing quicker as a new domain-server image build
doesn't include all the library builds.
So, you can build the base only once for each version of Qt and
supporting libraries and then `buildDS` when you want to
rebuild with a new version of Vircadia.

The build argument `TAG` specifies the GIT pull tag. This defaults
to `master`.

The script `pushDocker.sh` pushes  the image to my repository.
Modify it to your purposes.

Thus, the steps to build are:

```
    ./buildBase.sh
    ./buildDS.sh
    ./pushDocker.sh
```

There are running scripts supplied that can be used when running
the domain-server container.
On the system the domain-server is to be run on, pull this
repository and then `run-domain-server.sh`. This will pull
the image from `hub.docker.com` and start the docker container.

The domain-server can be stopped with `stop-domain-server.sh`
and an update/restart (stop container, pull new image, start container)
is done with `update-domain-server.sh`.

The above run scripts generate local files saving the domain-server
configuration, cache, and state. Domain-server files show up in
`server-dotlocal`. There are several layers of sub-directories
which are used if you are running multiple grids and multiple
domain-server instances.

Log files for the running domain-server are found in the
directory `server-logs` with sub-directories for the grids
and instances.

By default, the domain-server will point to the metaverse-server
`https://metaverse.vircadia.com/live` but this can be changed
by passing the metaverse URL to the run script:

```
    ./run-domain-server.sh https://metaverse.example.com ice.example.com
```

`run-domain-server.sh` uses "--networking=host" because the assignment
clients use ports all over the place. The assignment-clients need some
taming on their port usage and some parameterization for running
multiple domain-servers on one processor.

TODO: Break out all the assignment clients into separate containers running
on the 'internal' virtual network. Use `docker-compose` or similar to
start them all up and to do scaling for things like audio load, etc.

## Ice Server

The Docker image also contains an ice-server which you can run if you
are running your own grid (using your own metaverse-server, etc).
The script `run-ice-server.sh` will run the ice server.
It requires the URL of the metaverse-server.

## Versioning

There is a special kludge to get the version of the built domain-server.

```
    docker run --rm --entrypoint /home/cadia/getVersion.sh misterblue/vircadia-domain-server
```

This runs the image and outputs JSON text giving the version the domain-server
was built with:

```JSON
   {
      "GIT_COMMIT": "GitCommitString",
      "GIT_COMMIT_SHORT": "FirstEightCharactersOfGitCommitString",
      "GIT_TAG": "GitBranchTag",
      "BUILD_DATE": "YYYYMMDD.HHMM",
      "BUILD_DAY": "YYYYMMDD"
      "VERSION_TAG": "TAG-YYYYMMDD-xxxxxxxx"
   }

```
