#!/bin/bash

# Test/benchmark access to cloud bucket by downloading, renaming, 
# uploading, and deleting a file. Concatenate results into a 
# simple report file.
#
# The user must setup AWS credentials before running this script.

#=============================================
#echo Create a bunch of files
#=============================================
aws_sync=$1
num_files=$2
file_size=$3
size_unit=$4
# Use standard cloud bucket handle from PW UI (i.e. key button)
s3_bucket="s3://${BUCKET_NAME}/"

# If you need to install AWS CLI locally (i.e. without root)
# specify the local install prefix here and include trailing
# slash, e.g.
#aws_prefix=${HOME}/bin/
# If you already have AWS CLI installed, just leave blank
aws_prefix=' '

sync_dir=tmp_${RANDOM}
mkdir -p $sync_dir

for (( ii=1; ii<=$num_files; ii++ ))
do
    file_name=tmp_${ii}.bin
    fallocate -x -l ${file_size}${size_unit} ${sync_dir}/${file_name}
    echo $RANDOM >> ${sync_dir}/${file_name}
done
wait

dir_size_mb=$(du -BMB $sync_dir | tail -1 | awk -FM '{print $1}')
#echo Testing AWS CLI with $sync_dir with size $dir_size_mb MB

dir_file_list="${sync_dir}/*.bin"
#echo Contents in $sync_dir 
#for file in $dir_file_list
#do
#    echo $file
#done

#=============================================
#echo Get object info
#=============================================
#size_mb=$(aws s3 ls $test_obj | awk '{print $3/1.0e6}')
#echo Object size: $size_mb

if [ ${aws_sync} = "sync" ]
then

	#=============================================
	#echo Upload objects with AWS sync
	#=============================================
	# Force seconds timer to always start at minimum
	# value of 1 in case operation takes less than a
	# second (b/c resulting rate will be div by 0).
	SECONDS=1
	${aws_prefix}aws s3 sync $sync_dir ${s3_bucket}${sync_dir} > /dev/null
	ul_s=$SECONDS
	ul_r=$(echo $dir_size_mb $ul_s | awk '{print $1/$2}' )
	#echo Serial upload took $ul_s s at $ul_r MB/s

	#=============================================
	#echo Serial copy data from bucket with AWS sync
	#=============================================
	SECONDS=1
	${aws_prefix}aws s3 sync ${s3_bucket}${sync_dir} ${sync_dir}.serial > /dev/null
	dl_s=$SECONDS
	dl_r=$(echo $dir_size_mb $dl_s | awk '{print $1/$2}' )
	#echo Serial download took $dl_s s at $dl_r MB/s
	
	#=============================================
	#echo Clean up local and bucket data
	#=============================================
	SECONDS=1
	${aws_prefix}aws s3 rm --recursive ${s3_bucket}${sync_dir} > /dev/null
	rm_s=$SECONDS
	rm_r=$(echo $dir_size_mb $rm_s | awk '{print $1/$2}' )
	#echo Bucket object delete took $rm_s s at $rm_r MB/s

else

	#=============================================
	#echo Upload objects in parallel with AWS cp
	#=============================================
	SECONDS=1
	for file in $dir_file_list
	do
    		bn=$(basename ${file})
    		${aws_prefix}aws s3 cp ${file} ${s3_bucket}${sync_dir}/${bn} > /dev/null &
	done
	wait
	ul_s=$SECONDS
	ul_r=$(echo $dir_size_mb $ul_s | awk '{print $1/$2}' )
	#echo Parallel upload took $ul_s s at $ul_r MB/s
	
	#=============================================
	#echo Parallel copy data from bucket with AWS cp
	#=============================================
	SECONDS=1
	for file in $dir_file_list
	do
    		bn=$(basename $file)
    		${aws_prefix}aws s3 cp ${s3_bucket}${file} ${sync_dir}.parallel/${bn} > /dev/null &
	done
	wait
	dl_s=$SECONDS
	dl_r=$(echo $dir_size_mb $dl_s | awk '{print $1/$2}' )
	#echo Parallel download took $dl_s s at $dl_r MB/s 
	
	#=============================================
	#echo Clean up local and bucket data
	#=============================================
	SECONDS=1
	${aws_prefix}aws s3 rm --recursive ${s3_bucket}${sync_dir} > /dev/null
	rm_s=$SECONDS
	rm_r=$(echo $dir_size_mb $rm_s | awk '{print $1/$2}' )
	#echo Bucket object delete took $rm_s s at $rm_r MB/s

fi

#=============================================
#echo Done
#=============================================
rm -rf ${sync_dir}*
echo $aws_sync $num_files $file_size $size_unit SZ_MB $dir_size_mb UL_S_R $ul_s $ul_r DL_S_R $dl_s $dl_r RM_S_R $rm_s $rm_r

