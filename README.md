# Overview
Tools for using Matlab/Octave with the Gradescope Autograder.

# Writing test files
See the companion repository at https://bitbucket.org/tronroberto/mautogradeexampletests for specific instructions and example test files.

# How to use the autograder template
The directory `autograderTemplate` contains the files to be submitted on Gradescope for the autograder. 

This template is not meant to actually contain tests; instead it setups access to a Git repository containing the actual tests. To use the template, follow these steps:
* Copy a SSH deploy key in the autograder directory (file `id_rsa_deploy_key`).
* Add the deploy key to your GitHub or BitBucket repository to enable read access.
* Modify the script `setup_variables` with the information for your repository (`GIT_HOST` and `GIT_REPO` variables).
* Run the script `make_autograder` to produce the `zip` file to upload to Gradescope

This template is derived from the instructions at https://gradescope-autograders.readthedocs.io/en/latest/git_pull/

# Running tests
You can run a test suite (group of tests) using the command `mautogradeSuiteRunTests('filename')`. If `filename` is:
* A single file, only the tests in that file will be run.
* A directory, the script will look for all the `.m` files starting or ending with the word `test` (case insensitive). The results from all tests in all such files will be concatenated.
The results of the test are produced on the standard output using the JSON format; see https://gradescope-autograders.readthedocs.io/en/latest/specs/ for details on the output content. The output intended to be redirected to the `result.json` file used by Gradescope, as done in the provided `run_autograder` BASH script.

## Example tests
1. Clone the example tests from https://bitbucket.org/tronroberto/mautogradeexampletests to any directory, say "path/to/exampleTests"
2. From mAutograde's directory, run "mautogradeSuiteRunTests /path/to/exampleTests"

# Known bugs and limitations
- The framework does not support setup/tear-down of test fixtures.
- The function mautogradeCmpEq does not work correctly for values such as Inf and Nan when a comparison tolerance is specified.

# mAutograde base files and development notes
The `.m` files contain Octave/Matlab functions to run simple tests, collect the results, and write them to standard output.

## mautogradeSuiteRunTests
The main function to run a suite (group) of tests. Evaluates test functions to get test results, runs `mautogradeSuiteScan` to obtain option information about the tests, and uses `mautogradeSuiteJsonWriter` to collate and write the results.

## mautogradeSuiteJsonWriter
Integrates the results from the tests (produced from `mautogradeFunctionRunTests`) with the corresponding meta-information (options obtained from `mautogradeSuiteScan`).

## mautogradeSuiteScan
Parser that finds options for test functions.

## mautogradeFunctionRunTests
Used in the main function of a test file to run all the tests in that file.

## mautogradeTestInOut
Used to write tests comparing expected results of functions on given inputs.

## Utility functions
* `mautogradeAny2Str`: gives a string representation of variables that are structs, arrays, cells, doubles, or strings.
* `mautogradeJsonWriter`: writes a struct as a JSON output to a given file handle.
* `mautogradeEnsureCell`: outputs the input as a cell, if it is not already.
* `mautogradeAppendOutput`: similar to `sprintf`, but appends the formatted output to a given string, using a separator between the two.
* `mautogradeFunctionNameJoin`: formats a test name from the names of the files and functions.
* `mautogradeFunctionDescriptionDefault`: generates a default description from the test function name.
* `mautogradeOptionList` and `mautogradeOptionBaseRegexp`: returns the list of options and the regexp used to match them in SuiteScan.


