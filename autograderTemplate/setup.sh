#!/usr/bin/env bash
set -x #echo every command

# Gradescope setup
AUTOGRADER_DIR="/autograder"
AUTOGRADER_DIR_SOURCE="${AUTOGRADER_DIR}/source"

git clone https://bitbucket.org/tronroberto/mautograde.git /tmp
cp -f /mautograde/autograderTemplate/* ${AUTOGRADER_DIR_SOURCE}

cd "${AUTOGRADER_DIR}/source"
source setup_variables.sh
cd "${AUTOGRADER_DIR}/source"
source setup_git.sh
cd "${AUTOGRADER_DIR}/source"
source setup_octave.sh
cd "${AUTOGRADER_DIR}/source"
source setup_cvx.sh
