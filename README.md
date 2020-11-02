# vircadia-domin-server-docker

Docker version of Vircadia domain-server built with vircadia-builder.

This repository includes files to build the Docker image (build*.sh)
and run the Docker image (*-domain-server.sh).

The Dockerfile is broken into two halves to make building and
debugging a little easier. `buildBase.sh` builds an image that
contains the built Vircadia services as well as the supporting
libraries (Qt, ...). `buildDS.sh` uses the base image to create
the domain-server image that just includes the needed binaries.

The build argument `TAG` specifies the GIT pull tag. This defaults
to `master`.

The script `pushDocker.sh` pushes  the image to my repository.

Thus, the steps to build are:

```
    ./buildBase.sh
    ./buildDS.sh
    ./pushDocker.sh
```

On the system the domain-server is to be run on, pull this
repository and then `run-domain-server.sh`. This will pull
the image from `hub.docker.com`.

By default, the domain-server will point to the metaverse-server
`https://metaverse.vircadia.com/live` but this can be changed
by passing the metaverse URL to the run script:

```
    ./run-domain-server.sh https://metaverse.example.com ice.example.com
```

The run script will create directories `server-dotlocal` and `server-logs`
that hold persistant data for the domain-server.

TODO: Break out all the assignment clients into separate containers running
on the 'internal' virtual network. Use `docker-compose` or similar to
start them all up and to do scaling for things like audio load, etc.

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
