#!/bin/bash

echo "Please choose a test type:"
echo "1) GoodTests"
echo "2) BadTests"
read -p "Enter your choice (1/2): " test_type

case $test_type in
    1)
        TEST_TYPE="GoodTests"
        ;;
    2)
        TEST_TYPE="BadTests"
        ;;
    *)
        echo "Invalid test type choice. Exiting."
        exit 1
        ;;
esac

echo "Please choose a test directory:"
echo "1) Tests/Phase2/Espresso/$TEST_TYPE"
echo "2) Tests/Phase2/Espresso+/$TEST_TYPE"
echo "3) Tests/Phase2/Espresso++/$TEST_TYPE"
read -p "Enter your choice (1/2/3): " choice

case $choice in
    1)
        TEST_DIR="Tests/Phase2/Espresso/$TEST_TYPE"
        TEST_NAME="Espresso"
        ;;
    2)
        TEST_DIR="Tests/Phase2/Espresso+/$TEST_TYPE"
        TEST_NAME="EspressoPlus"
        ;;
    3)
        TEST_DIR="Tests/Phase2/Espresso++/$TEST_TYPE"
        TEST_NAME="EspressoStar"
        ;;
    *)
        echo "Invalid directory choice. Exiting."
        exit 1
        ;;
esac

mkdir -p Test_Results/Tests

OUTPUT_FILE="Test_Results/Tests/${TEST_NAME}_${TEST_TYPE}_results.txt"

PASSED=0
FAILED=0

echo "Test Results for $TEST_DIR" > $OUTPUT_FILE

for test_file in $TEST_DIR/*.java; do
    file_name=$(basename $test_file)
    
    OUTPUT=$(./espressoc $test_file 2>&1)
    status=$?
    
    echo "$OUTPUT" >> $OUTPUT_FILE
    
    if [ $status -eq 0 ]; then
        echo "✅ $file_name - PASSED" | tee -a $OUTPUT_FILE
        ((PASSED++))
    else
        echo "❌ $file_name - FAILED" | tee -a $OUTPUT_FILE
        ((FAILED++))
    fi
done

echo "-----------------------------------" | tee -a $OUTPUT_FILE
echo "Total tests: $((PASSED + FAILED))" | tee -a $OUTPUT_FILE
echo "Passed: $PASSED" | tee -a $OUTPUT_FILE
echo "Failed: $FAILED" | tee -a $OUTPUT_FILE

if [ $FAILED -ne 0 ]; then
    exit 1
fi
