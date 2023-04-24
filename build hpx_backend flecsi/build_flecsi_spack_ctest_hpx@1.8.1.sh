#!/bin/bash -e

#SBATCH --job-name=flecsi_spack_build
#SBATCH --output=flecsi_spack_build.out
#SBATCH --nodes=1
#SBATCH --time=05:00:00
#SBATCH --partition=medusa

# Copyright (c) 2022 R. Tohid (@rtohid)
# Distributed under the Boost Software License, Version 1.0. (See accompanying
# file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

# set -xe
#module purge
#module load openmpi gcc cmake git boost
module load gcc cmake git 

BASE_DIR=$(pwd)
SPACK_DIR=${BASE_DIR}/spack
FLECSI_DIR=${BASE_DIR}/flecsi2

mkdir -p ${BASE_DIR}

if [ ! -d ${FLECSI_DIR} ]; then
  git clone --branch task_local https://github.com/STEllAR-GROUP/flecsi2.git ${FLECSI_DIR}
fi
if [ ! -d ${SPACK_DIR} ]; then
  git clone https://github.com/spack/spack.git ${SPACK_DIR}
  source ${SPACK_DIR}/share/spack/setup-env.sh
  spack env create -d ${BASE_DIR}
  spack env activate -p ${BASE_DIR}
  spack repo add ${FLECSI_DIR}/spack-repo/
  spack add flecsi%gcc@12.2.0 backend=hpx +flog +unit ^boost@1.80.0
  spack install --only dependencies flecsi%gcc@12.2.0 backend=hpx +flog +unit ^boost@1.80.0
fi
spack env activate -p ${BASE_DIR}

#build flecsi from source with spack env
cmake -S ${FLECSI_DIR} -B ${FLECSI_DIR}/cmake-build -DFLECSI_BACKEND=hpx -DENABLE_UNIT_TESTS=ON
cmake --build ${FLECSI_DIR}/cmake-build/ --parallel

#ctest
cd ${FLECSI_DIR}/cmake-build/
ctest

#exit spack
despacktivate

