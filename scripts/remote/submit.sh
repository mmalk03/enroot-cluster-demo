#!/usr/bin/env bash

#SBATCH --constraint=dgx
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=32GB
#SBATCH --gpus=1
#SBATCH --time=0-12:00:00
#SBATCH --partition=short
#SBATCH --export=ALL
#SBATCH --account=mandziuk-lab

date
echo "SLURMD_NODENAME: ${SLURMD_NODENAME}"
echo "SLURM_JOB_ID: ${SLURM_JOB_ID}"
echo "CUDA_VISIBLE_DEVICES: ${CUDA_VISIBLE_DEVICES}"
echo "Training command: python ${1}" "${@:2}"
echo "Enroot version: $(enroot version)"
enroot start \
  --rw \
  -e CUDA_VISIBLE_DEVICES="${CUDA_VISIBLE_DEVICES}" \
  -m /home2/faculty/mmalkinski/projects/eden-cluster-demo/demo:/app/demo \
  -m /home2/faculty/mmalkinski/projects/eden-cluster-demo/models:/app/models \
  -m /etc/slurm:/etc/slurm \
  mikomel-demo-latest \
  python "${1}" "${@:2}"
date
