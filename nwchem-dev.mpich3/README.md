Build command  

```
FC=gfortran ARMCI_NETWORK=MPI-PR MPICH=3.4.2 apptainer build --fakeroot nwchem.simg  Singularity
```

Slurm file for frontier
```
#!/bin/bash 
#SBATCH -t 00:15:00 
#SBATCH -A XXXX
#SBATCH -N2
#SBATCH -J nwchem
#SBATCH -o nwchem.out
#SBATCH -e nwchem.err
module  load rocm/5.7.1
module  load cray-mpich-abi
export MPICH_GPU_SUPPORT_ENABLED=1
export APPTAINERENV_LD_LIBRARY_PATH="$CRAY_MPICH_DIR/lib-abi-mpich:$CRAY_MPICH_ROOTDIR/gtl/lib:/opt/rocm/lib:/opt/rocm/lib64:$CRAY_LD_LIBRARY_PATH:$LD_LIBRARY_PATH:/opt/cray/pe/lib64"
export APPTAINER_CONTAINLIBS="/usr/lib64/libcxi.so.1,/usr/lib64/libjson-c.so.3,/lib64/libtinfo.so.6,/usr/lib64/libnl-3.so.200,/usr/lib64/libgfortran.so.5,/usr/lib64/libjansson.so.4"
export APPTAINERENV_LD_PRELOAD=$CRAY_MPICH_ROOTDIR/gtl/lib/libmpi_gtl_hsa.so.0:
MYFS=$(findmnt -r -T . | tail -1 |cut -d ' ' -f 1)
export BINDS=/usr/share/libdrm,/var/spool/slurmd,/opt/cray,${MYFS}

srun  -N2  --tasks-per-node 1 --gpus-per-task=1 apptainer exec --bind $BINDS --workdir `pwd` --rocm nwchem.simg nwchem "filename"

```