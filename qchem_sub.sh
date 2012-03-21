#!/bin/sh
#
# Simple script to submit a job to the Sun Grid Engine

# Take the first argument of the script
BASE=`pwd`

for x in "$@"; do
 INPUT=${x}
 qsub -N ${INPUT%%.qcin} /usr/local/bin/qchem_sge.sh ${INPUT} ${BASE}
 echo "Q-Chem job ${INPUT} submitted to the queue."
done
