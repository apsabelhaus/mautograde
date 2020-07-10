#Install Octave
apt-get --yes install octave

# Setup octave path
echo "addpath ('$MAUTOGRADE_DIR')" >> $HOME/.octaverc
#Note: only the base mAutograde files are added to the path. The test files will be added by the Octave scripts when running the tests.

