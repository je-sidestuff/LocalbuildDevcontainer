#!/bin/bash

# This script shims the test_bootstrap_lbdc and test_load_lbdc scripts into the execution path.

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

export LBDC_TEST_DIR="${SCRIPT_DIR}/../"
export TEST_LOG="${LBDC_TEST_DIR}/test_log.txt"

"${SCRIPT_DIR}/test_bootstrap_lbdc_loader.sh"

"${SCRIPT_DIR}/.lbdc-cache/scripts/loader/test_load_lbdc.sh"
