#!/usr/bin/env bash
CVX_DIR="${AUTOGRADER_DIR}/toolbox/cvx"
mkdir -p ${CVX_DIR}

apt-get install libopenblas-dev liboctave-dev

git clone -b rework https://github.com/cvxr/CVX.git/ ${CVX_DIR}
cd ${CVX_DIR}
rm -rf sdpt3/
rm -rf sedumi/
git clone https://github.com/sqlp/sdpt3.git
git clone https://github.com/sqlp/sedumi.git
cp "${AUTOGRADER_DIR_SOURCE}/cvx_compile_all.m" .
