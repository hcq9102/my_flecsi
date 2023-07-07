#!/bin/bash -e

#SBATCH --job-name=flecsi_spack_build
#SBATCH --output=flecsi_spack_build.out
#SBATCH --nodes=1
#SBATCH --time=05:00:00
#SBATCH --partition=medusa



# set -xe
#module purge
#module load openmpi gcc cmake git boost
module load gcc/12.2.0 cmake/3.23.2 git 

BASE_DIR=$(pwd)
SPACK_DIR=${BASE_DIR}/spack
FLECSI_DIR=${BASE_DIR}/flecsi2

mkdir -p ${BASE_DIR}

# (checkout the specific commit)already done manually before running this script.
if [ ! -d ${FLECSI_DIR} ]; then
  git clone --branch task_local2 https://github.com/STEllAR-GROUP/flecsi2.git ${FLECSI_DIR}
  cd ${FLECSI_DIR}
  git checkout COMMIT_HASH
fi
# spack build
if [ ! -d ${SPACK_DIR} ]; then
  git clone https://github.com/spack/spack.git ${SPACK_DIR}
  source ${SPACK_DIR}/share/spack/setup-env.sh
  spack env create -d ${BASE_DIR}
  spack env activate -p ${BASE_DIR}
  sed -i 's/unify: false/unify: true/' ${BASE_DIR}/spack.yaml
  spack repo add ${FLECSI_DIR}/spack-repo/
  spack external find ninja cmake openmpi python autoconf automake perl m4 ca-certificates-mozilla
  spack add flecsi%gcc@12.2.0 backend=hpx +flog +unit ^hpx@master ^boost@1.80.0
  spack concretize -f
  spack install 
fi
spack env activate -p ${BASE_DIR}

#build flecsi from source with spack env
cmake -S ${FLECSI_DIR} -B ${FLECSI_DIR}/cmake-build-commit -DFLECSI_BACKEND=hpx -DENABLE_UNIT_TESTS=ON -DCMAKE_BUILD_TYPE=Release #-DCMAKE_INSTALL_PREFIX=/work/chuanqiu/zz223_medusa_hpxmaster1/install
cmake --build ${FLECSI_DIR}/cmake-build-commit/ --parallel

#make install
#cd ${FLECSI_DIR}/cmake-build/
#make install 
#ctest
cd ${FLECSI_DIR}/cmake-build-commit/
ctest

#exit spack
despacktivate

