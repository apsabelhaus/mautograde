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

# Compile CVX under octave
cp "${AUTOGRADER_DIR_SOURCE}/cvx_compile_all.m" .
octave --no-gui --eval "cvx_compile_all"

# Patch the display.m function to avoid errors in Octave
patch "/autograder/toolbox/cvx/lib/@cvxcnst/display.m" "${AUTOGRADER_DIR_SOURCE}/display.m.patch"
