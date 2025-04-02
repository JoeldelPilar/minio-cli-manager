#!/bin/bash

# Test suite for MinIO Terminal Handler
# This is a basic structure for testing the main functionality

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Get the directory where this script is located and set project root
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$( cd "$SCRIPT_DIR/.." && pwd )"
MAIN_SCRIPT="$PROJECT_ROOT/src/minio_terminal_handler.sh"

# Test counter
TESTS_PASSED=0
TESTS_FAILED=0

# Function to run a test
run_test() {
    local test_name="$1"
    local test_command="$2"
    local expected_result="$3"
    
    echo "Running test: $test_name"
    
    # Run the test command
    local result
    result=$($test_command)
    local exit_code=$?
    
    if [ "$expected_result" = "success" ] && [ $exit_code -eq 0 ]; then
        echo -e "${GREEN}✓ Test passed${NC}"
        ((TESTS_PASSED++))
    elif [ "$expected_result" = "failure" ] && [ $exit_code -ne 0 ]; then
        echo -e "${GREEN}✓ Test passed${NC}"
        ((TESTS_PASSED++))
    elif [ -n "$expected_result" ] && [ "$result" = "$expected_result" ]; then
        echo -e "${GREEN}✓ Test passed${NC}"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}✗ Test failed${NC}"
        ((TESTS_FAILED++))
    fi
}

# Test 1: Check if script exists
echo "Checking script at: $MAIN_SCRIPT"
run_test "Script exists" "ls $MAIN_SCRIPT" "success"

# Test 2: Check if script is executable
run_test "Script is executable" "test -x $MAIN_SCRIPT" "success"

# Test 3: Check shebang
run_test "Script has correct shebang" "head -n 1 $MAIN_SCRIPT" "#!/bin/bash"

# Print summary
echo "----------------------------------------"
echo "Test Summary:"
echo -e "${GREEN}Passed: $TESTS_PASSED${NC}"
echo -e "${RED}Failed: $TESTS_FAILED${NC}"
echo "----------------------------------------"

# Exit with appropriate status
if [ $TESTS_FAILED -eq 0 ]; then
    exit 0
else
    exit 1
fi 