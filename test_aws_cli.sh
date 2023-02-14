#!/bin/bash

# Test/benchmark access to cloud bucket by downloading, renaming, 
# uploading, and deleting a file. Concatenate results into a 
# simple report file.
#
# The user must setup AWS credentials before running this script.

#=============================================
echo Create a bunch of files
#=============================================
num_files=$1
file_size=$2
size_unit=$3
s3_bucket="s3://cloud-data-benchmarks/"

sync_dir=tmp_${RANDOM}
mkdir -p $sync_dir

for (( ii=1; ii<=$num_files; ii++ ))
do
    file_name=tmp_${ii}.bin
    fallocate -l ${file_size}${size_unit} ${sync_dir}/${file_name}
    echo $RANDOM >> ${sync_dir}/${file_name}
done

dir_size_mb=$(du -BMB $sync_dir | tail -1 | awk -FM '{print $1}')
echo Testing AWS CLI with $sync_dir with size $dir_size_mb MB


#=============================================
#echo Get object info
#=============================================
#size_mb=$(aws s3 ls $test_obj | awk '{print $3/1.0e6}')
#echo Object size: $size_mb

#=============================================
echo Upload objects
#=============================================
# Force seconds timer to always start at minimum
# value of 1 in case operation takes less than a
# second (b/c resulting rate will be div by 0).
SECONDS=1
aws s3 sync $sync_dir ${s3_bucket}${sync_dir} > /dev/null
ul_s=$SECONDS
ul_r=$(echo $dir_size_mb $ul_s | awk '{print $1/$2}' )
echo Upload took $ul_s seconds at $ul_r MB/s

#=============================================
#echo Rename with move
#=============================================
#tmp_name=${bn}.tmp-$(date +%s)
#mv $bn $tmp_name

#=============================================
#echo Copy back up to bucket
#=============================================
#SECONDS=0
#aws s3 cp ${tmp_name} ${bucket}/${tmp_name} > /dev/null
#ul_s=$SECONDS
#ul_r=$(echo $size_mb $ul_s | awk '{print $1/$2}' )
#echo Upload took $ul_s seconds at $ul_r MB/s

#=============================================
#echo Delete copy from bucket
#=============================================
#SECONDS=0
#aws s3 rm ${bucket}/${tmp_name} > /dev/null
#rm_s=$SECONDS
#rm_r=$(echo $size_mb $rm_s | awk '{print $1/$2}' )
#echo Delete took $rm_s seconds at $rm_r MB/s

#=============================================
# Clean up
#=============================================
#rm $tmp_name

