# NWChem singularity for EMSL cascade 

Singularity recipe for NWChem to use on EMSL cascade with OpenMPI 3.1.3

## how to build on cascade
```
curl -LJO https://raw.githubusercontent.com/edoapra/nwchem-singularity/master/nwchem-701.ompi313.ivybridge/Singularity
singularity build --fakeroot nwchem.simg  Singularity
```
## how to run on cascade

From a Slurm script or inside an interactive Slurm session
```
module purge
module load openmpi/3.1.3
mpirun  singularity exec ./nwchem.simg nwchem "input file"
```
## Using image from the Singularity Library on EMSL cascade
Instead of building on cascade, you can pull the image from the Singularity Library with two options
### option \#1
```
export https_proxy=http://proxy.emsl.pnl.gov:3128
module purge
module load openmpi/3.1.3
mpirun singularity exec library://edoapra/default/nwchem701.ivybridge.mpich321.mpipr:sha256.03560327f67283ba0622594293bd35c61b4dc1e00228561b6cb5bd484ae205bc nwchem "input file"
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
module load openmpi/3.1.3
mpirun singularity exec library://edoapra/default/nwchem701.ivybridge.ompi313.mpipr.sif:sha256.cbe7277eb444b08b3cd5142d436a827a9c5b11861ee81cbb377ee5a1b4fe7044 nwchem siosi3.nw
```

P.S. This might require to execute the following command to cache the image prior to submit the script with `sbatch`
```
singularity pull library://edoapra/default/nwchem701.ivybridge.ompi313.mpipr.sif:sha256.cbe7277eb444b08b3cd5142d436a827a9c5b11861ee81cbb377ee5a1b4fe7044
```
### option \#2
```
singularity pull library://edoapra/default/nwchem701.ivybridge.ompi313.mpipr.sif:sha256.cbe7277eb444b08b3cd5142d436a827a9c5b11861ee81cbb377ee5a1b4fe7044
```
The name of the downloaded image is `nwchem701.ivybridge.ompi313.mpipr.sif_sha256.cbe7277eb444b08b3cd5142d436a827a9c5b11861ee81cbb377ee5a1b4fe7044.sif`, therefore the commands to run it on cascade will change to

```
module purge
module load openmpi/3.1.3
mpirun singularity exec ./nwchem701.ivybridge.ompi313.mpipr.sif_sha256.cbe7277eb444b08b3cd5142d436a827a9c5b11861ee81cbb377ee5a1b4fe7044.sif nwchem "input file"
```
