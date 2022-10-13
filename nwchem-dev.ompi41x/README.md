# NWChem singularity for EMSL tahoma

Singularity recipe for NWChem to use on EMSL tahoma with OpenMPI 4.0.5, UCX 1.8.1 and GCC compileers

## how to build on tahoma
```
curl -LJO https://raw.githubusercontent.com/edoapra/nwchem-singularity/master/nwchem-dev.ompi41x/Singularity
module purge
module load gcc/9.3.0
module load openmpi/4.1.4
singularity build --fakeroot nwchem.simg  Singularity
```
## how to run on tahoma

From a Slurm script or inside an interactive Slurm session
```
module purge
module load gcc/9.3.0
module load openmpi/4.1.4
srun  singularity exec ./nwchem.simg nwchem "input file"
```
## Using image from the Singularity Library on EMSL tahoma
Instead of building on cascade, you can pull the image from the Singularity Library with the command

```
singularity pull oras://ghcr.io/edoapra/nwchem-singularity/nwchem-dev.ompi40x:latest
```
Once the the image has been downloaded, there are two options for using it

### option \#1 Use the Singularity library name

#### Interactive session
```
export https_proxy=http://proxy.emsl.pnl.gov:3128
module purge
module load openmpi/4.0.5
srun singularity exec oras://ghcr.io/edoapra/nwchem-singularity/nwchem-dev.ompi40x:latest nwchem "input file"
```

#### Slurm batch script

This is an example of a Slurm batch script
```
#!/bin/bash
#SBATCH -N 2
#SBATCH -t 00:29:00
#SBATCH -A allocation_name
#SBATCH --ntasks-per-node 36
#SBATCH -o singularity_library.output.%j
#SBATCH -e ./singularity_library.err.%j
#SBATCH -J singularity_library
#SBATCH --export ALL
source /etc/profile.d/modules.sh
export https_proxy=http://proxy.emsl.pnl.gov:3128
module purge
module load gcc/9.3.0
module load openmpi/4.1.4
singularity pull -F --name ~/nwchem_`id -u`.img  oras://ghcr.io/edoapra/nwchem-singularity/nwchem-dev.ompi41x:latest
srun -N $SLURM_NNODES -n $SLURM_NNODES cp ~/nwchem_`id -u`.img /big_scratch/nwchem.img
srun singularity exec /big_scratch/nwchem.img nwchem "input file"
```


### option \#2 Use the name of the downloaded image
```
singularity pull library://edoapra/default/nwchem-dev.ompi41x:latest
```
The name of the downloaded image is `oras://ghcr.io/edoapra/nwchem-singularity/nwchem-dev.ompi41x:latest`, therefore the commands to run it on tahoma will change to

```
module purge
module load gcc/9.3.0
module load openmpi/4.1.4
singularity exec oras://ghcr.io/edoapra/nwchem-singularity/nwchem-dev.ompi41x:latest nwchem "input file"
```
