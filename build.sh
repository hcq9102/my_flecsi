  #!/bin/bash

  #SBATCH --job-name=flecsi_spack_build
  #SBATCH --output=flecsi_spack_build.out
  #SBATCH --nodes=1
  #SBATCH --time=05:00:00
  #SBATCH --partition=medusa
  
  # set -xe
  module load openmpi
  module load gcc/9.2.1
  
  BASE_DIR=$(pwd)
  SPACK_DIR=${BASE_DIR}/spack
  FLECSI_DIR=${BASE_DIR}/flecsi
  
  mkdir -p ${BASE_DIR}
  
  if [ ! -d ${FLECSI_DIR} ]; then
    git clone --branch task_local https://github.com/STEllAR-GROUP/flecsi2.git ${FLECSI_DIR}
  fi
  if [ ! -d ${SPACK_DIR} ]; then
    git clone https://github.com/spack/spack.git ${SPACK_DIR}
    source ${SPACK_DIR}/share/spack/setup-env.sh
    spack env create -d ${BASE_DIR}
    spack env activate -p ${BASE_DIR}
    sed -i 's/unify: false/unify: true/' ${BASE_DIR}/spack.yaml
    spack repo add ${FLECSI_DIR}/spack-repo/
    spack external find ninja cmake openmpi python autoconf automake perl m4 hpx
    spack add googletest
    spack add flecsi%gcc@9.2.1 backend=hpx +hdf5 
    spack concretize -f
    spack install
  fi
