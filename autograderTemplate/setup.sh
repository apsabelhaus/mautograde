#!/usr/bin/env bash
set -x #echo every command

# Gradescope setup
AUTOGRADER_DIR="/autograder"
AUTOGRADER_DIR_SOURCE="${AUTOGRADER_DIR}/source"

cd "${AUTOGRADER_DIR}/source"
source setup_variables
cd "${AUTOGRADER_DIR}/source"
source setup_git.sh
cd "${AUTOGRADER_DIR}/source"
source setup_octave.sh


