#This file is meant to be sourced by setup.sh and run_autograder

#Variables to change to match your setup
GIT_HOST="github.com" #change to github.com if using GitHub
GIT_REPO="git@$GIT_HOST:apsabelhaus/mautogradeexampletests_tron.git"

# Gradescope setup
AUTOGRADER_DIR="/autograder"

#Variables for the setup and run scripts
SSH_DIR="$HOME/.ssh"

#Test repository destination
MAUTOGRADE_DIR=$AUTOGRADER_DIR/mAutograde
MAUTOGRADE_TESTS_REPO_DIR=$AUTOGRADER_DIR/tests
MAUTOGRADE_TESTS_DIR=$MAUTOGRADE_TESTS_REPO_DIR/assignment1
