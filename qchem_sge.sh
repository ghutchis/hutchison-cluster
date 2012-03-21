#!/bin/sh
# Force SGE to use bash
#$ -S /bin/bash
#$ -R y
# pe mpi 4

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

# Set up Q-Chem environment
export QC=/usr/local/qchem
if [ -e ${QC}/bin/qchem.setup.sh ]; then
  source ${QC}/bin/qchem.setup.sh
fi

export QCSCRATCH=/scratch/${USER}
export PATH="${QC}/bin":"${QC}/gbin":"${QC}/exe":"${QC}/util":"${PATH}"
export QCRSH=ssh

cd ${SCRATCH}
FILENAME=${INPUT%%.qcin}
qchem ${INPUT} ${FILENAME}.qcout

# Cleanup
if [ -f ${FILENAME}.qcout ]; then
  gzip -9 ${FILENAME}.qcout
  cp ${FILENAME}.qcout.gz ${BASE}
fi

if [ `echo *.chk` != '*.chk' ]; then
  mv `echo *.chk` ${FILENAME}.chk
  gzip -9 ${FILENAME}.fchk
  cp ${FILENAME}.fchk.gz ${BASE}
fi

# Don't delete scratch directory for now
#cd $BASE
#rm -rf ${SCRATCH}
