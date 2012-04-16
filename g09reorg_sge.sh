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
NAME=${INPUT%%.xyz}

# OK, we start out with a file that needs to go through babel
echo "%nproc=4
%mem=1GB
%chk=${NAME}
#t B3LYP/6-31G(d) OPT" >/tmp/opt1
echo "%nproc=4
%mem=1GB
#t B3LYP/6-31G(d) SP" >/tmp/sp1

# Now copy the file into scratch
cd $BASE
if [ -f ${INPUT} ]; then
  babel ${INPUT} -xf /tmp/opt1 ${SCRATCH}/${NAME}.com
else
  exit
fi

# Set up G09 environment
export g09root=/usr/local
export GAUSS_SRCDIR=${SCRATCH}
. $g09root/g09/bsd/g09.profile


cd ${SCRATCH}

# Remove any old *.gz files
sed -e 's/0  3/0  1/' <${NAME}.com >${NAME}.new
mv ${NAME}.new ${NAME}.com
g09 ${NAME}.com ${NAME}.g09

echo "%nproc=4
%mem=1GB
%chk=${NAME}
%NoSave
#t B3LYP/6-31G(d) OPT Geom=Checkpoint

Cation

1  2

" >${NAME}+.com
g09 ${NAME}+.com ${NAME}+.g09

# cation electronic, neutral geometry
babel ${NAME}.g09 -xf /tmp/sp1 ${NAME}@.com
sed -e 's/0  1/1  2/' <${NAME}@.com >${NAME}@.new
mv ${NAME}@.new ${NAME}@.com
g09 ${NAME}@.com ${NAME}@.g09

# neutral electronic, cation geometry
babel ${NAME}+.g09 -xf /tmp/sp1 ${NAME}+@.com
sed -e 's/1  2/0  1/' <${NAME}+@.com >${NAME}+@.new
mv ${NAME}+@.new ${NAME}+@.com
g09 ${NAME}+@.com ${NAME}+@.g09

rm ${NAME}+.g09.gz
rm ${NAME}+@.g09.gz
gzip -9 ${NAME}*.g09
cp ${NAME}*.g09.gz $BASE

# final cleanup
cd $BASE
rm -rf ${SCRATCH}
