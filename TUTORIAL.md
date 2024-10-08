# Tutorial for creating and setting up autograders from a private Git repository

## Quickstart Guide

Below is a more detailed explanation of how `mAutograde` works, from Roberto Tron.

To quickly use the autograder with the pass-in-arguments approach, rather than manually editing the scripts:

1. Put your tests in a private repository, `.../p/`, and create a folder `p/autograder`
2. Optional: add the path to the `make_autograder` executable to your shell. We have provided the `add_make_autograder_path.sh` file to edit your `~/.profile` for you, run it from the subdirectory `autograderTemplate` of this repository. (Otherwise, you will need to exectute `autograderTemplate/make_autograder` via its whole path.)
3. Generate a deploy key for `p` per Roberto's instructions below (<https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key>), add the public key to Github/Bitbucket. Assume the private key is called `~/.ssh/p_deploy`
4. NOTE, the private key must have correct permissions or else Github will complain. Be sure to double check that all the necessary files are executable as well.
5. Open a terminal in `p/autograder` and run the `make_autograder` script there, using the arguments described in the help for that script. It will copy the files from the `autograderTemplate` directory, and your private deploy key, to the working directory (that's why you're in `p/autograder`), patch the variables and setup scripts appropriately, and zip up the `autograder.zip` archive
6. Upload your `autograder.zip` to Gradescope

Note: do NOT run `make_autograder` in a directory that's publicly available or in a public repository. You will expose your private deploy key, and GitGuardian will get angry at you if you try to push it.

Note: do NOT run `make_autograder` from the same directory as it currently resides. It will overwrite parts of the other files. It must be run elsewhere so these files are copied THEN modified.

## Cloning `mAutograde` and the example tests

This tutorial will use three repositories.

1.  `mAutograde`
    (<https://tronroberto@bitbucket.org/tronroberto/mautograde>) ::
    The main test harness to run and debug tests, and to setup the
    Gradescope programming assignment.
2.  `mAutograde Example Tests`
    (<https://tronroberto@bitbucket.org/tronroberto/mautogradeexampletests>)
    :: The tests that will be run by Gradescope.
3.  `mAutograde Example Solution`
    (<https://tronroberto@bitbucket.org/tronroberto/mautogradeexamplesolution>)
    :: A solution to the assignment, which will double also as a
    submission to test the autograder.

Clone the three repositories into the same directory. Your directory
should look as follows

    -   tutorials
        -   mAutograde
        -   mAutogradeExampleSolution
        -   mAutogradeExampleTests

The following steps will go over the steps you will need to
perform when starting a new submission from scratch. The repositories
above already implement these steps, and you will be able to simply
follow along.

## Create the solution to the assignment

While it is possible to create a new assignment without having a working
solution, this is, naturally, not recommended. For this tutorial, we
assume that we have a working submission with three functions:

`function1.m`
:   Returns the sum of the elements in the second input plus the first
    input plus 3.

`function2.m`
:   Splits a list according to a pivot.

`function3.m`
:   Compute the sum of two values, a string representation of the sum,
    and checks if the sum is greater than zero.

The functions are rather trivial, and are mostly used as a pretext for
illustrating how to write the tests.

## Create the tests for the solution

Conventionally, each function will have a *test suite* contained in a
file with name `⟨nameOfFunction⟩_autoTest.m`. Note that the
`_autoTest.m` suffix is mandatory, `mAutograde` will **not consider as
tests** files without this suffix (this is useful to include extra code
that is necessary to create more complex tests, but does not constitute
a test suite). See the file `WRITING_TESTS.md` and the test suites
included in the `mAutogradeExampleTests` repository for details on how
to write the tests, including standard tests running the built-in
`mAutograde` hinter, an testing for the size and type of the outputs.

## Setting up the path

Add the directories for `mAutograde` and the tests to the Matlab path,
e.g.:

``` matlab
cd tutorial/mAutograde
addpath(pwd)
cd ../mAutogradeExampleTests/
addpath(pwd)
```

## \[optional\] Create random test data

`mAutograde` provides facilities to

1.  Create random inputs for the functions;
2.  Run the inputs through the solution to get expected outputs;
3.  Specify how to compare the expected outputs with the actual outputs
    produced by a Gradescope submission;
4.  Save all the information above in a file to include in the tests.

Detailed information on this process is given in the example files
`function1_autoTestData.m`, `function2_autoTestData.m`,
`function3_autoTestData.m`. Run the three files to create the test
datasets. A couple of notes:

-   Each file will save a `.mat` file (same name, different extension)
    in the sibling directory `mAutogradeExampleTests` which contains the
    actual tests.
-   It will also modify the MAX~SCOREBEFORENORMALIZATION~ option to
    match the number of input/output pairs generated by the tests. ⚠
    Currently the code modifies the MAX~SCOREBEFORENORMALIZATION~ option
    for **all** tests, including `hinter`, `types`, and `dimensions`;
    this is incorrect and is on the TODO list of fixes.
-   Running the data creation file will suggest also the command to run
    the corresponding test suite locally (see below).

## Run the tests locally

It is a good idea to run the test locally against the solution. Change
directory to the submission, and then run the tests.

``` matlab
cd ../mAutogradeExampleSolution
mautogradeSuiteRunTests('function1_autoTest.m','quickReport')
mautogradeSuiteRunTests('function2_autoTest.m','quickReport')
mautogradeSuiteRunTests('function3_autoTest.m','quickReport')
```

The `quickReport` option shows the results of the tests in a more
readable manner. By default, the function `mautogradeSuiteRunTests` will
produce the YAML file that Gradescope needs to read the results. Check
that all the tests return the expected scores (if the `MAX_SCORE` or
`MAX_SCORE_BEFORE_NORMALIZATION` options are not set correctly, the
tests might return scores that are below/above the expected ones;
`mAutograde` will give a warning in the latter case, but it will not
stop the tests).

## Prepare the Gradescope assignment

There are a few steps in order to bring the autograders to Gradescope.

### Move the test files to a **private** Git repository

Push all the files for the tests to a repository on BitBucket or GitHub
(for the tutorial, this step has already been done). The repository
should be private, so that students do not have access to the tests

### Obtain a *deploy key*

If the repository is private, Gradescope will not be able to clone it by
default. To solve this problem, generate a *deploy key* file called
`id_rsa_deploy_key`, upload it to BitBucket
(<https://bitbucket.org/blog/deployment-keys>) or GitHub
(<https://docs.github.com/en/authentication/connecting-to-github-with-ssh/managing-deploy-keys>),
and copy it into the `mAutograde/autograderTemplate` directory. With
this key, Gradescope will be able to securely pull from the repository
(i.e., it will have only read-only access). The `id_rsa_deploy_key` in
the repository corresponds to the `mAutogradeExampleTest` repository.

### Configure the assignment files for Gradescope and create the zip archive

Edit the file `mAutograde/autograderTemplate/setup_variables.sh`, and in
particular the following variables:

`GIT_HOST`
:   Either `bitbucket.org` or `github.com`, depending on the provider
    used.

`GIT_REPO`
:   The SSH url of the repository for the tests. The deployment key
    should correspond to this repository.

`MAUTOGRADE_TESTS_DIR`
:   The subdirectory in the repository with the tests to use. This
    allows to have a single repository (and a single deploy key) for
    multiple assignments.

Compress all the files from `mAutograde/autograderTemplate` into an
archive called `archive.zip`, or run the `make_autograder` script which
will perform this step for you (requires the `bash` interpreter). The
files are derived from the instructions at
<https://gradescope-autograders.readthedocs.io/en/latest/git_pull/>.

### Create and test the Gradescope programming assigment

Create a new programming assigment on Gradescope using the `archive.zip`
file created at the previous step. After Gradescope create the image,
use the \"Test autograder\" link to upload the reference solution and
check that the tests work as expected.

# TODO
List of additions for the tutorial:
- Examples of tests for corner cases
- Tests for invariance for function2
