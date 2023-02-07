#!/bin/bash

# Wrapper to run an postprocess test results

# Run test
./test_aws_cli.sh &> test.log.tmp

# Process results
size=$(grep size test.log.tmp | awk '{print $3}')
dr=$(grep real test.log.tmp | sed 's/s/ /g' | sed 's/m/ /g' | awk -v s=$size 'NR==1 {print s/(($2*60.0) + $3)}')
ur=$(grep real test.log.tmp | sed 's/s/ /g' | sed 's/m/ /g' | awk -v s=$size 'NR==2 {print s/(($2*60.0) + $3)}')

echo File size MiB $size
echo Download rate MiB/s $dr
echo Upload rate MiB/s $ur

rm test.log.tmp

