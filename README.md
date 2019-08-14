# Overview
Tools for using Matlab/Octave with the Gradescope Autograder

# mAutograde base files
The m files contain Octave/Matlab functions to run simple tests, collect the results, and write them to standard output, which is then intended to be redirected to the `result.json` file used by Gradescope. See https://gradescope-autograders.readthedocs.io/en/latest/specs/ for details on the output format.

## Known limitations
The framework does not support setup/tear-down of test fixtures.

# How to use the autograder template
The directory `autograderTemplate` contains the files to be submitted on Gradescope for the autograder. 

This template is not meant to actually contain tests; instead it setups access to a Git repository containing the actual tests. To use the template, follow these steps:
* Copy a SSH deploy key in the autograder directory (file `id_rsa_deploy_key`).
* Add the deploy key to your GitHub or BitBucket repository to enable read access.
* Modify the script `setup_variables` with the information for your repository (`GIT_HOST` and `GIT_REPO` variables).
* Run the script `make_autograder` to produce the `zip` file to upload to Gradescope

This template is derived from the instructions at https://gradescope-autograders.readthedocs.io/en/latest/git_pull/
