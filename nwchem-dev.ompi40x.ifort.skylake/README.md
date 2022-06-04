# NWChem singularity for EMSL tahoma

Singularity recipe for NWChem to use on EMSL tahoma with OpenMPI 4.0.x and Intel ifort

## how to build on cascade
```
curl -LJO https://raw.githubusercontent.com/edoapra/nwchem-singularity/master/nwchem-dev.ompi40x.ifort.skylake/Singularity
singularity build --fakeroot nwchem.simg  Singularity
```
## how to run on cascade

From a Slurm script or inside an interactive Slurm session
```
module purge
module load openmpi
srun  singularity exec ./nwchem.simg nwchem "input file"
```
## Using image from the Singularity Library on EMSL cascade
Instead of building on cascade, you can pull the image from the Singularity Library with the command

```
singularity pull library://edoapra/default/nwchem-dev.ompi40x.ifort.skylake:latest
```
Once the the image has been downloaded, there are two options for using it

### option \#1 Use the Singularity library name

#### Interactive session
```
export https_proxy=http://proxy.emsl.pnl.gov:3128
module purge
module load openmpi/3.1.3
srun singularity exec library://edoapra/default/nwchem-dev.ompi40x.ifort.skylake:latest nwchem "input file"
```

#### Slurm batch script

This is an example of a Slurm batch script
```
#!/bin/bash
#SBATCH -N 2
#SBATCH -t 00:29:00
#SBATCH -A allocation_name
#SBATCH --ntasks-per-node 18
#SBATCH -o singularity_library.output.%j
#SBATCH -e ./singularity_library.err.%j
#SBATCH -J singularity_library
#SBATCH --export ALL
source /etc/profile.d/modules.sh
export https_proxy=http://proxy.emsl.pnl.gov:3128
module purge
module load openmpi
# remove old images
rm -f ./nwchems_`id -u`.img
# pull new image to the current directory
singularity pull --name ./nwchems_`id -u`.img pull library://edoapra/default/nwchem-dev.ompi40x.ifort.skylake:latest
# copy image from current directory to local /big_scratch/ on compute nodes
srun -N $SLURM_NNODES -n $SLURM_NNODES cp ./nwchems_`id -u`.img /big_scratch/nwchems.img
# run
srun singularity exec /big_scratch/nwchems.img nwchem  "file name"
```


### option \#2 Use the name of the downloaded image
```
singularity pull library://edoapra/default/nwchem-dev.ompi40x.ifort.skylake:latest
```
The name of the downloaded image is `library://edoapra/default/nwchem-dev.ompi40x.ifort.skylake:latest`, therefore the commands to run it on tahoma will change to

```
module purge
module load openmpi
singularity exec library://edoapra/default/nwchem-dev.ompi40x.ifort.skylake:latest nwchem "input file"
```
