# Enroot cluster demo

The repository demonstrates a simple setup to build and run [enroot](https://github.com/NVIDIA/enroot) images on a computing cluster with no direct access to docker.
Key highlights:
1. [Vagrant](https://github.com/hashicorp/vagrant) is used to provision a VM with docker and enroot installed.
2. The docker image is built in the VM and exported to an enroot image.
3. The enroot image is synced from the guest VM to the host.
4. Two sample images from the nvidia NGC catalog are used: [tensorflow](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/tensorflow) and [pytorch](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/pytorch).

Prerequisites:
1. Set up passwordless ssh to the computing cluster. In this repository, the host is named `eden`.
2. Update hard-coded strings based on your needs (e.g. the docker image name).

## Usage

### Local

For development purposes, here are the scripts and commands which can be run locally:
1. `./scripts/build_image.sh` – Build docker image.
2. `docker run mikomel/demo:latest python demo/main.py` – Run docker container.
3. `./scripts/install_enroot.sh` – Install enroot.
4. `enroot import --output ~/enroot/demo-latest.sqsh dockerd://mikomel/demo:latest` – Convert docker image to enroot image.
5. `enroot create ~/enroot/demo-latest.sqsh` – Create enroot image.
6. `enroot start demo-latest` – Start enroot container.

### Remote

To sync files between local and remote machines, run the following locally:
```bash
./scripts/remote/rsync.sh
```
The project files are mounted to the running container (see `-m` in `submit.sh`), which allows to update code running in the container without rebuilding the whole image. 

To build the enroot image from scratch, run the following on the remote machine:
```bash
sbatch ./scripts/remote/build_enroot_image.sh
```
It will build the enroot image in a VM provisioned by Vagrant.
This has to be run each time your dependencies change (or generally the content of the Dockerfile).

To run a container with the sample script, run:
```bash
sbatch ./scripts/remote/submit.sh demo/main.py -n 5
```

Output logs of the job can be viewed with:
```bash
tail -f slurm-<JOB_ID>.out
```
