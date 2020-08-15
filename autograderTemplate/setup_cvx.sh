#!/usr/bin/env bash
CVX_DIR="${AUTOGRADER_DIR}/toolbox/cvx"
mkdir -p ${CVX_DIR}

# Get libraries necessaries for compilation
apt-get --yes install libopenblas-dev liboctave-dev

# Get CVX and solvers
git clone -b rework https://github.com/cvxr/CVX.git/ ${CVX_DIR}
cd ${CVX_DIR}
rm -rf sdpt3/
rm -rf sedumi/
git clone https://github.com/sqlp/sdpt3.git
git clone https://github.com/sqlp/sedumi.git
cp "${AUTOGRADER_DIR_SOURCE}/cvx_compile_all.m" .

# Compile CVX under octave
octave --no-gui --eval "cvx_compile_all"
