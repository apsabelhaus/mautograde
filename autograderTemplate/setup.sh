#!/usr/bin/env bash

source setup_variables

# Setting up SSH access to the Git host
mkdir -p $SSH_DIR
sed 's/GIT_HOST/$GIT_HOST/' ssh_config_template > $SSH_DIR/config

# Make sure to include your private key here
cp id_rsa_deploy_key $SSH_DIR/.ssh/id_rsa_deploy_key
# To prevent host key verification errors at runtime
ssh-keyscan -t rsa $GIT_HOST >> $SSH_DIR/known_hosts

# Clone autograder files (public repository)
git clone https://tronroberto@bitbucket.org/tronroberto/mautograde.git $MAUTOGRADE_DIR

#Clone autograder actual tests (requires deploy key)
git clone $GIT_REPO $MAUTOGRADE_TESTS_DIR

#Install Octave
apt-get install octave

# Setup octave path
echo "addpath ('$MAUTOGRADE_DIR')" >> $HOME_DIR/.octaverc
#Note: only the base mAutograde files are added to the path. The test files will be added by the Octave scripts when running the tests.

