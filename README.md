## nwchem-singularity
Singularity recipe for NWChem to use on EMSL cascade with mpich 3.2.1

# how to build on cascade
```

singularity build --fakeroot nwchem.simg  Singularity
```
# how to run on cascade

From a Slurm script or inside an interactive Slurm session
```
module purge
module load mpich/3.2.1
mpirun  singularity exec ./nwchem.simg nwchem "input file"
```
