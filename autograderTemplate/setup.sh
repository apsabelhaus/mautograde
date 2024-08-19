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
# add-apt-repository -y universe
# add-apt-repository -y multiverse
# add-apt-repository -y restricted
apt update

cd "${AUTOGRADER_DIR}/source"
source setup_variables.sh
cd "${AUTOGRADER_DIR}/source"
source setup_git.sh
cd "${AUTOGRADER_DIR}/source"
source setup_octave.sh
# CVX dropped support for Octave, and patching it correctly is too cumbersome
# cd "${AUTOGRADER_DIR}/source"
# source setup_cvx.sh

# additionally, install python for mautograder_additional_tests if desired
apt-get install -y python3 python3-pip python3-dev
pip3 install pypdf openpyxl