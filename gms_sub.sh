#!/bin/sh
#
# Simple script to submit a job to the Sun Grid Engine

# Take the first argument of the script
INPUT=$1
OUTPUT=$2
BASE=`pwd`

qsub -N ${INPUT%%.inp} /usr/local/bin/gms_sge.sh ${INPUT} ${BASE}

echo "GAMESS-US job ${INPUT} submitted to the queue."
