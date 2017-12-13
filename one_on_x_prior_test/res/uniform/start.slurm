#!/bin/bash

# Job name:
#SBATCH --job-name=r0001
#
# Project:
#SBATCH --account=nn9244k
#
# Wall clock limit:
#SBATCH --time=160:00:00
#
# Processor and memory usage:
#SBATCH --ntasks-per-node=5
#SBATCH --nodes=1
#SBATCH --mem-per-cpu=5G
#
# Outfile:
#SBATCH --output=snapp_out.txt

## Set up job environment:
source /cluster/bin/jobsetup

## Copy input files to the work directory:
cp snapp.xml $SCRATCH
if [ -f "snapp.log" ];
then
  cp snapp.log $SCRATCH
fi
if [ -f "snapp.trees" ];
then
  cp snapp.trees $SCRATCH
fi
if [ -f "snapp.xml.state" ];
then
  cp snapp.xml.state $SCRATCH
fi
cp beast.jar $SCRATCH
cp -r SNAPP $SCRATCH

## Run BEAST:
cd $SCRATCH
java -jar -Xmx4g beast.jar -threads 4 -seed 6671 snapp.xml

# Copy files back to the submission directory:
cp snapp.* $SUBMITDIR
