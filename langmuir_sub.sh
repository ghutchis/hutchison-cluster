#!/bin/sh
#
# Simple script to submit a Gaussian job to the Sun Grid Engine

# Take the first argument of the script
INPUT=$1
OUTPUT=$2
BASE=`pwd`

qsub -N ${INPUT} /usr/local/bin/langmuir_sge.sh "${INPUT}.inp" ${INPUT} ${BASE}

echo "Langmuir job ${INPUT} submitted to the queue."
