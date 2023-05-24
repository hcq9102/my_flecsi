#!/bin/bash

# Set the list of core counts to test 32 24 16 8 4 2 1 1 2 4 8 
CORE_COUNTS=(1 2 4 8 16 24 32 40)

# Path to executables
exe_dir="/work/chuanqiu/zzzztest523/flecsi2/cmake-build_release/test"
# Set the list of executable paths to test
EXECUTABLES=(
    "$exe_dir/exec/kernel"
    "$exe_dir/exec/task"
    "$exe_dir/exec/future"
    "$exe_dir/run/flog"
    "$exe_dir/run/program-options"
    "$exe_dir/topo/index"
    "$exe_dir/topo/coloring"
    "$exe_dir/topo/unstructured"
    "$exe_dir/topo/fixed"
    "$exe_dir/topo/set"
    "$exe_dir/topo/narray"
    "$exe_dir/topo/ntree_geometry"
    "$exe_dir/util/array_ref"
    "$exe_dir/util/common"
    "$exe_dir/util/color_map"
    "$exe_dir/util/unit"
    "$exe_dir/util/serialize"
    "$exe_dir/util/set_utils"
    "$exe_dir/util/point"
    "$exe_dir/util/filling_curve"
    "$exe_dir/util/hashtable"
    # add more executable paths here
)

ITERATIONS=3
#set localities number
NUM=4 

for ((j=1; j<=$ITERATIONS; j++)); do
    echo "Running iteration $j..."
    # Create a directory to save the test results
    RESULTS_DIR="522test_release_csv_($NUM)localities_iter_$j" 

    mkdir -p $RESULTS_DIR
    # Create a csv file to store the run times of each executable
    CSV_FILE="$RESULTS_DIR/test_result.csv"
    echo "Executable,Cores,Run Time(s)" > $CSV_FILE

    CSV_FILE2="$RESULTS_DIR/cores_sumtime_n$NUM.csv"
    echo "Cores,Mean Run Time(s)" > "$CSV_FILE2"
    # Loop over the specified core counts
    for i in "${CORE_COUNTS[@]}"; do
        echo "Running tests with $i cores..."
        # Create a log file for the current core count
        LOG_FILE="$RESULTS_DIR/test_result_$i.log"
        echo "Logging test results to $LOG_FILE for $i cores..."

        # Run all executable files under the specified number of cores and save the results to the csv file
        sum_time=0
        for executable in "${EXECUTABLES[@]}"; do
            echo "Running $(basename $executable) with $i cores..."
            START_TIME=$(date +%s.%N)
            
            mpirun -n $NUM $executable --backend-args="--hpx:ini=hpx.max_background_threads!=$i" --backend-args="--hpx:print-bind" >$LOG_FILE 2>&1
            
            END_TIME=$(date +%s.%N)
            ELAPSED_TIME=$(echo "$END_TIME - $START_TIME" | bc)
            sum_time=$(echo "$sum_time + $ELAPSED_TIME" | bc)
            echo "$(basename $executable), $i, $ELAPSED_TIME" >> $CSV_FILE
        done

        # Print the sum elapsed time for the current number of cores
        echo "Sum elapsed time for $i cores: $sum_time seconds" >> $LOG_FILE
        echo "$i,$sum_time" >> "$CSV_FILE2"
        echo "Finished tests with $i cores. Results saved to $LOG_FILE"
        echo ""
    done
    cd $exe_dir
    rm *.current
done  
cd $exe_dir
rm *.current  
