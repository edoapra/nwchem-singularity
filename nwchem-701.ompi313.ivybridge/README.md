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
