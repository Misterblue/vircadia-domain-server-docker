#! /bin/bash
# Script that is run in built image and generates version information
# Invocation: buildVersion.sh directoryOfBuildSources targetVersionDirectory gitTagUsedToBuild

# Generates files:
#   GIT_COMMIT: the commit used to build
#   GIT_COMMIT_SHORT: short form of the GIT commit
#   GIT_TAG: contains TAG used to do the GIT fetch
#   BUILD_DATE: when the build happened (YYYYMMDD.HHMM)
#   BUILD_DAY: when the build happened (YYYYMMDD)
#   VERSION_TAG: $BUILD_DATE-$GIT_COMMIT_SHORT
#   VERSION.json: JSON file containing the above:
#           {
#               "GIT_COMMIT": "COMMIT",
#               "GIT_COMMIT_SHORT": "COMMIT_SHORT",
#               "GIT_TAG": "TAG",
#               "BUILD_DATE": "YYYMMDD.HHMM",
#               "BUILD_DAY": "YYYMMDD"
#               "VERSION_TAG": "YYYMMDD.hhmm-xxxxxxxx"
#           }

SRCDIR=${1:-/opt/vircadia/source}
VERDIR=${2:-/opt/vircadia/version}
GIT_TAG=${3:-master}

VERFILE=VERSION.json

cd "${SRCDIR}"
BUILD_DATE=$(date "+%Y%m%d.%H%M")
BUILD_DAY=$(date "+%Y%m%d")
GIT_COMMIT=$(git rev-parse HEAD)
GIT_COMMIT_SHORT=$(git rev-parse --short HEAD)
VERSION_TAG=${BUILD_DATE_SHORT}-${GIT_TAG}-${GIT_COMMIT_SHORT}

mkdir -p "${VERDIR}"
cd "${VERDIR}"
echo $BUILD_DATE > "BUILD_DATE"
echo $BUILD_DAY > "BUILD_DAY"
echo $GIT_COMMIT > "GIT_COMMIT"
echo $GIT_COMMIT_SHORT > "GIT_COMMIT_SHORT"
echo $GIT_TAG > "GIT_TAG"
echo $VERSION_TAG > "VERSION_TAG"

echo "{"                                                > "${VERFILE}"
echo "  \"BUILD_DATE\": \"${BUILD_DATE}\","             >> "${VERFILE}"
echo "  \"BUILD_DAY\": \"${BUILD_DAY}\","               >> "${VERFILE}"
echo "  \"GIT_COMMIT\": \"${GIT_COMMIT}\","             >> "${VERFILE}"
echo "  \"GIT_COMMIT_SHORT\": \"${GIT_COMMIT_SHORT}\"," >> "${VERFILE}"
echo "  \"GIT_TAG\": \"${GIT_TAG}\","                   >> "${VERFILE}"
echo "  \"VERSION_TAG\": \"${VERSION_TAG}\""            >> "${VERFILE}"
echo "}"                                                >> "${VERFILE}"







