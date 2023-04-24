#!/bin/bash -e


module load openmpi
module load gcc/12.2.0

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
  spack external find ninja cmake openmpi python autoconf automake perl m4 hpx ca-certificates-mozilla
  spack add googletest
  spack add flecsi%gcc@12.2.0 backend=hpx +flog +unit ^hpx ^boost@1.80.0
  spack concretize -f
  spack install 
fi
