#!/bin/bash

# Wrapper to run a bunch of tests
testlogfile=$1

# Run tests
# transfer_type, number_files, file_size, file_size_unit

# Use AWS sync
./test_aws_cli.sh sync 1 1 MB >> $testlogfile
./test_aws_cli.sh sync 10 1 MB >> $testlogfile
./test_aws_cli.sh sync 100 1 MB >> $testlogfile
./test_aws_cli.sh sync 1000 1 MB >> $testlogfile

./test_aws_cli.sh sync 1 10 MB >> $testlogfile
./test_aws_cli.sh sync 10 10 MB >> $testlogfile
./test_aws_cli.sh sync 100 10 MB >> $testlogfile
./test_aws_cli.sh sync 1000 10 MB >> $testlogfile

./test_aws_cli.sh sync 1 100 MB >> $testlogfile
./test_aws_cli.sh sync 10 100 MB >> $testlogfile
./test_aws_cli.sh sync 100 100 MB >> $testlogfile

./test_aws_cli.sh sync 1 1000 MB >> $testlogfile
./test_aws_cli.sh sync 10 1000 MB >> $testlogfile

# Use parallel file copy
# Commented out since this tends to be slower.
#./test_aws_cli.sh pacp 1 1 MB >> $testlogfile
#./test_aws_cli.sh pacp 10 1 MB >> $testlogfile
#./test_aws_cli.sh pacp 100 1 MB >> $testlogfile
#./test_aws_cli.sh pacp 1000 1 MB >> $testlogfile

#./test_aws_cli.sh pacp 1 10 MB >> $testlogfile
#./test_aws_cli.sh pacp 10 10 MB >> $testlogfile
#./test_aws_cli.sh pacp 100 10 MB >> $testlogfile
#./test_aws_cli.sh pacp 1000 10 MB >> $testlogfile

#./test_aws_cli.sh pacp 1 100 MB >> $testlogfile
#./test_aws_cli.sh pacp 10 100 MB >> $testlogfile
#./test_aws_cli.sh pacp 100 100 MB >> $testlogfile

#./test_aws_cli.sh pacp 1 1000 MB >> $testlogfile
#./test_aws_cli.sh pacp 10 1000 MB >> $testlogfile
#done
