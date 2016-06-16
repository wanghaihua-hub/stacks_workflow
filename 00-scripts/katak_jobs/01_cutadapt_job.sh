#!/bin/bash
#SBATCH -J "cutadapt"
#SBATCH -o log_%j
#SBATCH -c 1
#SBATCH -p ibismini
#SBATCH -A ibismini
#SBATCH --mail-type=ALL
#SBATCH --mail-user=your.email@service.com
#SBATCH --time=1-00:00
#SBATCH --mem=24000

# Move to directory where job was submitted
cd $SLURM_SUBMIT_DIR

# Reduce number of CPUs here and above if you have less than 4 chips/lanes
./00-scripts/01_cutadapt.sh 1
