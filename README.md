# Overview

Tools for using Matlab/Octave with the Gradescope Autograder.

# General considerations

A few caveats:

-   It really uses Octave rather than Matlab. For the most part, this
    does not cause problems, although there are some edge cases where
    something works in Matlab but not on Octave (e.g., when stacking
    arrays with zero dimensions, or using function handles loaded from
    .mat files, Octave is more picky).
-   Generally speaking, mAutograde works by defining a special .m file
    with local test functions that run different tests. Typically you
    have some predefined inputs and outputs, and there are predefined
    functions that count how many actual outputs match the expected ones
    (without giving the exact input/output pairs to the students). See
    the next section and the corresponding companion repository for more
    details.
-   Currently, the setup scripts are configured to pull the tests from a
    git repository (on Github or BitBucket). It takes a little more
    effort to setup the repository, but then updating the tests becomes
    much faster, because it only requires a simple instead of going
    through the Gradescope interface and re-building the assignment. It
    is possible to configure the scripts to pull the tests from the
    Gradescope assignment itself, but this requires changes to
    mAutograde.

# Writing test files

See the companion repository at
<https://bitbucket.org/tronroberto/mautogradeexampletests> for specific
instructions and example test files.

# How to use the autograder

See the file TUTORIAL.md

# Running tests

You can run a test suite (group of tests) using the command
\`mautogradeSuiteRunTests(\'filename\')\`. If \`filename\` is:

-   A single file, only the tests in that file will be run.
-   A directory, the script will look for all the \`.m\` files starting
    or ending with the word \`test\` (case insensitive). The results
    from all tests in all such files will be concatenated.

The results of the test are produced on the standard output using the
JSON format; see
<https://gradescope-autograders.readthedocs.io/en/latest/specs/> for
details on the output content. The output intended to be redirected to
the \`result.json\` file used by Gradescope, as done in the provided
\`run~autograder~\` BASH script.

## Example tests

1.  Clone the example tests from
    <https://bitbucket.org/tronroberto/mautogradeexampletests> to any
    directory, say \"path/to/exampleTests\"
2.  From mAutograde\'s directory, run \"mautogradeSuiteRunTests
    /path/to/exampleTests\"

# Known bugs and limitations

-   The framework does not support setup/tear-down of test fixtures.
-   The function mautogradeCmpEq does not work correctly for values such
    as Inf and Nan when a comparison tolerance is specified.
-   If the expected and actual number of outputs of a function are
    different, the error messages are unhelpful
-   In the options for a test, if MAX~SCORE~\~=1,
    MAX~SCOREBEFORENORMALIZATION~ should be set to 1 by default.

# mAutograde base files and development notes

The \`.m\` files contain Octave/Matlab functions to run simple tests,
collect the results, and write them to standard output.

## mautogradeSuiteRunTests

The main function to run a suite (group) of tests. Evaluates test
functions to get test results, runs \`mautogradeSuiteScan\` to obtain
option information about the tests, and uses
\`mautogradeSuiteJsonWriter\` to collate and write the results.

## mautogradeSuiteJsonWriter

Integrates the results from the tests (produced from
\`mautogradeFunctionRunTests\`) with the corresponding meta-information
(options obtained from \`mautogradeSuiteScan\`).

## mautogradeSuiteScan

Parser that finds options for test functions.

## mautogradeFunctionRunTests

Used in the main function of a test file to run all the tests in that
file.

## mautogradeTestInOut

Used to write tests comparing expected results of functions on given
inputs.

## Utility functions

-   \`mautogradeAny2Str\`: gives a string representation of variables
    that are structs, arrays, cells, doubles, or strings.
-   \`mautogradeJsonWriter\`: writes a struct as a JSON output to a
    given file handle.
-   \`mautogradeEnsureCell\`: outputs the input as a cell, if it is not
    already.
-   \`mautogradeAppendOutput\`: similar to \`sprintf\`, but appends the
    formatted output to a given string, using a separator between the
    two.
-   \`mautogradeFunctionNameJoin\`: formats a test name from the names
    of the files and functions.
-   \`mautogradeFunctionDescriptionDefault\`: generates a default
    description from the test function name.
-   \`mautogradeOptionList\` and \`mautogradeOptionBaseRegexp\`: returns
    the list of options and the regexp used to match them in SuiteScan.

## Global setting for debugging

Set a structd \`mAutogradeOptions\` as global with the following fields

-   \`verbose\`: when \`true\`, do not capture the output of functions
    in a variable, and show various debugging information
-   \`breakOnError\`: when \`true\`, call \`keyboard()\` whenever an
    actual output does not match the expected output in a test, or when
    the submission code throws an exception
-   \`breakOnScoreOverflow\`: when \`true\`, call \`keyboard()\`
    whenever a normalized score from a comparison function is greater
    than one.
