#This file is meant to be sourced by setup.sh and run_autograder

#Variables to change to match your setup
GIT_HOST="bitbucket.org" #change to github.com if using GitHub
GIT_REPO="git@$GIT_HOST:tronroberto/mautogradeexampletests.git"

# Gradescope setup
AUTOGRADER_DIR="/autograder"

#Variables for the setup and run scripts
SSH_DIR="$HOME/.ssh"

#Test repository destination
MAUTOGRADE_DIR=$AUTOGRADER_DIR/mAutograde
MAUTOGRADE_TESTS_DIR=$AUTOGRADER_DIR/tests

