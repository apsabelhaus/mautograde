#This file is meant to be sourced by setup.sh and run_autograder

#Variables to change to match your setup
GIT_HOST="github.com" #change to github.com if using GitHub
GIT_REPO="git@$GIT_HOST:user/gradertestsrepo.git"

# allows us to pass in the name of an arbitrary private keyfile to make_autograder, e.g., for the solutions repo for this assignment
SSH_PRIVATE_KEYFILE="id_rsa_deploy_key"

# Gradescope setup
AUTOGRADER_DIR="/autograder"

#Variables for the setup and run scripts
SSH_DIR="$HOME/.ssh"

#Test repository destination
MAUTOGRADE_DIR=$AUTOGRADER_DIR/mAutograde
MAUTOGRADE_TESTS_REPO_DIR=$AUTOGRADER_DIR/tests
MAUTOGRADE_TESTS_DIR=$MAUTOGRADE_TESTS_REPO_DIR/assignment1
