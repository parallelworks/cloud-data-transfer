#!/bin/bash

# Test/benchmark access to cloud bucket by downloading, renaming, 
# uploading, and deleting a file. Concatenate results into a 
# simple report file.
#
# The user must setup AWS credentials before running this script.

#=============================================
echo Select file
#=============================================
# Big object - 6.3GB
test_obj="s3://cloud-data-benchmarks/ETOPO1_Ice_g_gmt4.csv"

# Small object - 100MB
#test_obj="s3://cloud-data-benchmarks/ETOPO1_Ice_g_gmt4_tenthdeg.csv"

bn=$(basename $test_obj)
bucket=$(dirname $test_obj)

echo Testing AWS CLI with: $test_obj cp to $bn

#=============================================
echo Get object info
#=============================================
size_mb=$(aws s3 ls $test_obj | awk '{print $3/1.0e6}')
echo Object size: $size_mb

#=============================================
echo Transfer object
#=============================================
time aws s3 cp $test_obj $bn > /dev/null

#=============================================
echo Rename with move
#=============================================
tmp_name=${bn}.tmp-$(date +%s)
mv $bn $tmp_name

#=============================================
echo Copy back up to bucket
#=============================================
time aws s3 cp ${tmp_name} ${bucket}/${tmp_name} > /dev/null

#=============================================
echo Delete copy from bucket
#=============================================
time aws s3 rm ${bucket}/${tmp_name} > /dev/null

#=============================================
# Clean up
#=============================================
rm $tmp_name

