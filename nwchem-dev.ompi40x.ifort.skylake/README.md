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
singularity pull library://edoapra/default/nwchem-dev.ompi40x.skylake:sha256.2f861d26d2424e979090d67ce83500df640c96a192b2942fc7f6c89f8e4f0b8b
```
Once the the image has been downloaded, there are two options for using it

### option \#1 Use the Singularity library name

#### Interactive session
```
export https_proxy=http://proxy.emsl.pnl.gov:3128
module purge
module load openmpi/3.1.3
srun singularity exec library://edoapra/default/nwchem-dev.ompi40x.skylake:sha256.2f861d26d2424e979090d67ce83500df640c96a192b2942fc7f6c89f8e4f0b8b
```

#### Slurm batch script

This is an example of a Slurm batch script
```
#!/bin/bash
#SBATCH -N 2
#SBATCH -t 00:29:00
#SBATCH -A allocation_name
#SBATCH -o singularity_library.output.%j
#SBATCH -e ./singularity_library.err.%j
#SBATCH -J singularity_library
#SBATCH --export ALL
source /etc/profile.d/modules.sh
export https_proxy=http://proxy.emsl.pnl.gov:3128
module purge
module load openmpi
pdsh -w "$SLURM_JOB_NODELIST" singularity pull library://edoapra/default/nwchem-dev.ompi40x.ifort.skylake:sha256.2f861d26d2424e979090d67ce83500df640c96a192b2942fc7f6c89f8e4f0b8b
srun singularity exec library://edoapra/default/nwchem-dev.ompi40x.skylake:sha256.2f861d26d2424e979090d67ce83500df640c96a192b2942fc7f6c89f8e4f0b8b
```


### option \#2 Use the name of the downloaded image
```
singularity pull library://edoapra/default/nwchem-dev.ompi40x.skylake:sha256.2f861d26d2424e979090d67ce83500df640c96a192b2942fc7f6c89f8e4f0b8b
```
The name of the downloaded image is `library://edoapra/default/nwchem-dev.ompi40x.sha256.2f861d26d2424e979090d67ce83500df640c96a192b2942fc7f6c89f8e4f0b8b`, therefore the commands to run it on tahoma will change to

```
module purge
module load openmpi
srun singularity exec ./library://edoapra/default/nwchem-dev.ompi40x.skylake:sha256.2f861d26d2424e979090d67ce83500df640c96a192b2942fc7f6c89f8e4f0b8b nwchem "input file"
```
