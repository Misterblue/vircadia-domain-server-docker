#! /bin/bash

export HIFI_METAVERSE_URL=${METAVERSE_URL:-https://metaverse.vircadia.com/live}
export ICE_SERVER_URL=${ICE_SERVER:-ice.vircadia.com:7337}

LOGDIR=/home/cadia/logs
mkdir -p "${LOGDIR}"

LOGDATE=$(date --utc "+%Y%m%d.%H%M")
LOGFILE=${LOGDIR}/domain-server-${LOGDATE}
ALOGFILE=${LOGDIR}/assignment-${LOGDATE}

RUNDIR=/opt/vircadia/install_master

cd "${RUNDIR}"

./run_assignment-client -t 0 -p 48000  >> "${ALOGFILE}-0.log" 2>&1 &
./run_assignment-client -t 1 -p 48001  >> "${ALOGFILE}-1.log" 2>&1 &
./run_assignment-client -t 6 -p 48006  >> "${ALOGFILE}-6.log" 2>&1 &
./run_assignment-client -t 3 -p 48003  >> "${ALOGFILE}-3.log" 2>&1 &
./run_assignment-client -t 5 -p 48005  >> "${ALOGFILE}-5.log" 2>&1 &
./run_assignment-client -t 4 -p 48004  >> "${ALOGFILE}-4.log" 2>&1 &
./run_assignment-client -t 2 --max 100 >> "${ALOGFILE}-2.log" 2>&1 &

sleep 1

./run_domain-server -i ${ICE_SERVER_URL} >> "${LOGFILE}.log" 2>&1
