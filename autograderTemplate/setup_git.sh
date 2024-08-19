source setup_ssh.sh

# Set Git identity (placeholder)
git config --global user.email "autograder@placeholder.org"
git config --global user.name "Gradescope Autograder"

# Clone mAutograder files (public repository / same as contains template)
git clone https://github.com/apsabelhaus/mautograde.git $MAUTOGRADE_DIR

#Clone autograder actual tests (requires deploy key)
git clone $GIT_REPO $MAUTOGRADE_TESTS_REPO_DIR
