#!/bin/sh
#
# Simple script to submit a job to the Sun Grid Engine

# Take the first argument of the script
BASE=`pwd`

for x in "$@"; do
 INPUT=${x}
 qsub -N a${INPUT%%.xyz} /usr/local/bin/g09reorg_sge.sh ${INPUT} ${BASE}
 echo "Gaussian Reorganization E job ${INPUT} submitted to the queue."
done
