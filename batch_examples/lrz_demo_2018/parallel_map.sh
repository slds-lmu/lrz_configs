#!/bin/bash
#SBATCH -o /home/hpc/pr74ze/ri89coc2/demos/res.out
#SBATCH -D /home/hpc/pr74ze/ri89coc2/demos
#SBATCH -J test_tuning
#SBATCH --get-user-env
#SBATCH --clusters=mpp2
#SBATCH --nodes=1-1
#SBATCH --cpus-per-task=28
#SBATCH --mail-type=end
#SBATCH --mail-user=xyz@xyz.de
#SBATCH --export=NONE
#SBATCH --time=00:10:00
#SBATCH --mem=800mb
source /etc/profile.d/modules.sh

Rscript parallel_map.R
