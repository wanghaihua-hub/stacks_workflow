#!/bin/bash
#SBATCH -J "rxcstacks"
#SBATCH -o log_%j
#SBATCH -c 1
#SBATCH -p ibismax
#SBATCH -A ibismax
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=YOUREMAIL
#SBATCH --time=8-00:00
#SBATCH --mem=50G

# Move to directory where job was submitted
cd $SLURM_SUBMIT_DIR

# Create stacks catalog
./00-scripts/stacks_6_cstacks_rx.sh
