
# Prepare the working directory as needed
verify_install_success () {

    if [ -f "${LBDC_TEST_DIR}/.devcontainer/devcontainer.json" ]; then
        echo "Successfully installed LBDC in ${LBDC_TEST_DIR}"
    else
        echo "Failed to detect installed devcontainer file."
        exit 1
    fi
}

# Set up temporary testing dir
export LBDC_TEST_DIR=$(mktemp -d -t lbdc-e2e-test-XXXX)
export TEST_LOG="${LBDC_TEST_DIR}/test_log.txt"
cd "${LBDC_TEST_DIR}" # TODO - should not need to change dirs.
echo "Performing end to end test in test dir ${LBDC_TEST_DIR}." | tee -a "${TEST_LOG}"

# Execute Install Phase
export LBDC_INSTALL_SOURCE_TYPE="local"
export LBDC_INSTALL_SOURCE_LOCATION=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )/../../" &> /dev/null && pwd )
export LBDC_INSTALL_NOCLEAN_WORKING_DIR="true"
echo "Calling: ${LBDC_INSTALL_SOURCE_LOCATION}/scripts/client/install_lbdc.sh" | tee -a "${TEST_LOG}"
bash "${LBDC_INSTALL_SOURCE_LOCATION}/scripts/client/install_lbdc.sh" 2>&1 | tee -a "${TEST_LOG}"

# Verify
verify_install_success

# Inject Test Hooks for Bootstrap, Load, and Run Phases
cp "${LBDC_INSTALL_SOURCE_LOCATION}/test/e2e/inject/vscode/test_launch.sh" \
    "${LBDC_TEST_DIR}/.devcontainer/launch.sh"

# Run vscode to execute remaining phases (Load, Run) and print cleanup command
if [ "${LBDC_INSTALL_SKIP_run_vscode}" != "true" ]; then
    code .
fi

cd --
