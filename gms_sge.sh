#!/bin/sh
# Force SGE to use bash
#$ -S /bin/bash
#$ -R y
#$ -pe mpi 4

# Take the first argument of the script
INPUT=$1
BASE=$2
SCRATCH=/scratch/${USER}/${JOB_ID}

# Set up the scratch directory if needed
if [ -d /scratch/${USER} ]; then
  touch /scratch/${USER}
else
  mkdir /scratch/${USER}
fi
mkdir ${SCRATCH}

# Now copy the file into scratch
cd $BASE
if [ -f ${INPUT} ]; then
  cp ${INPUT} ${SCRATCH} 
else
  exit
fi

cd ${SCRATCH}
FILENAME=${INPUT%%.inp}
gms ${INPUT}

# Cleanup
if [ -f ${FILENAME}.gamout ]; then
  gzip -9 ${FILENAME}.gamout
  cp ${FILENAME}.gamout.gz ${BASE}
fi

if [ -f ${FILENAME}.dat ]; then
  gzip -9 ${FILENAME}.dat
  cp ${FILENAME}.dat.gz ${BASE}
fi

cd $BASE
rm -rf ${SCRATCH}
