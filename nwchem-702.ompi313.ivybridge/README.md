# NWChem singularity for EMSL cascade 

Singularity recipe for NWChem to use on EMSL cascade with OpenMPI 3.1.3

## how to build on cascade
```
curl -LJO https://raw.githubusercontent.com/edoapra/nwchem-singularity/master/nwchem-702.ompi313.ivybridge/Singularity
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
Instead of building on cascade, you can pull the image from the Singularity Library with the command

```
singularity pull library://edoapra/default/nwchem-702.ompi313.ivybridge:sha256.cf4e2661f224ae6e5822756b4204f76e51c4eaaca71f7ac96a3a3a464d0b68d7
```
Once the the image has been downloaded, there are two options for using it

### option \#1 Use the Singularity library name

#### Interactive session
```
export https_proxy=http://proxy.emsl.pnl.gov:3128
module purge
module load openmpi/3.1.3
mpirun singularity exec library://edoapra/default/nwchem-702.ompi313.ivybridge:sha256.cf4e2661f224ae6e5822756b4204f76e51c4eaaca71f7ac96a3a3a464d0b68d7 nwchem "input file"
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
mpirun singularity exec library://edoapra/default/nwchem-702.ompi313.ivybridge:sha256.cf4e2661f224ae6e5822756b4204f76e51c4eaaca71f7ac96a3a3a464d0b68d7 nwchem siosi3.nw
```


### option \#2 Use the name of the downloaded image
```
singularity pull library://edoapra/default/nwchem-702.ompi313.ivybridge:sha256.cf4e2661f224ae6e5822756b4204f76e51c4eaaca71f7ac96a3a3a464d0b68d7
```
The name of the downloaded image is `nwchem-702.ompi313.ivybridge_sha256.cf4e2661f224ae6e5822756b4204f76e51c4eaaca71f7ac96a3a3a464d0b68d7.sif`, therefore the commands to run it on cascade will change to

```
module purge
module load openmpi/3.1.3
mpirun singularity exec ./nwchem-702.ompi313.ivybridge_sha256.cf4e2661f224ae6e5822756b4204f76e51c4eaaca71f7ac96a3a3a464d0b68d7.sif nwchem "input file"
```
