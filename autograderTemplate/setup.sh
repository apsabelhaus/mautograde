#!/usr/bin/env bash
set -x #echo every command

# Gradescope setup
AUTOGRADER_DIR="/autograder"
AUTOGRADER_DIR_SOURCE="${AUTOGRADER_DIR}/source"

# The line below is useful during debug of the setup scripts,
# otherwise it can be just ignored
# source setup_selfupdate

# Update Ubuntu apt sources
cd "${AUTOGRADER_DIR}/source"
cp us_sources.list /etc/apt/sources.list
apt update

cd "${AUTOGRADER_DIR}/source"
source setup_variables.sh
cd "${AUTOGRADER_DIR}/source"
source setup_git.sh
cd "${AUTOGRADER_DIR}/source"
source setup_octave.sh
cd "${AUTOGRADER_DIR}/source"
source setup_cvx.sh
