#!/bin/bash -e

#SBATCH --job-name=flecsi_spack_build
#SBATCH --output=flecsi_spack_build.out
#SBATCH --nodes=1
#SBATCH --time=05:00:00
#SBATCH --partition=medusa

# set -xe
#module purge
module load gcc/12.2.0 cmake/3.23.2 git 
#module load gcc/9.2.1 cmake git

BASE_DIR=$(pwd)
SPACK_DIR=${BASE_DIR}/spack
FLECSI_DIR=${BASE_DIR}/flecsi2

mkdir -p ${BASE_DIR}

if [ ! -d ${FLECSI_DIR} ]; then
  git clone --branch task_local2 https://github.com/STEllAR-GROUP/flecsi2.git ${FLECSI_DIR}
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
  spack add flecsi%gcc@12.2.0 backend=hpx +flog +unit ^hpx@master ^boost@1.80.0
  #spack add flecsi%gcc@9.2.1 backend=hpx +flog +unit ^hpx@master ^boost@1.80.0
  spack concretize -f
  spack install 
fi

#activate spack env
spack env activate -p ${BASE_DIR}

#build flecsi from source with spack env

#Release type
cmake -S ${FLECSI_DIR} -B ${FLECSI_DIR}/cmake-build_release -DFLECSI_BACKEND=hpx -DENABLE_FLOG=ON -DENABLE_UNIT_TESTS=ON -DCMAKE_BUILD_TYPE=Release 
cmake --build ${FLECSI_DIR}/cmake-build_release/ --parallel

#Debug type
cmake -S ${FLECSI_DIR} -B ${FLECSI_DIR}/cmake-build_debug -DFLECSI_BACKEND=hpx -DENABLE_FLOG=ON -DENABLE_UNIT_TESTS=ON -DCMAKE_BUILD_TYPE=Debug
cmake --build ${FLECSI_DIR}/cmake-build_debug/ --parallel

#exit spack
spack env deactivate #despacktivate
