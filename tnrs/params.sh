#!/bin/bash

##############################################################
# Application parameters
# Check and change as needed
##############################################################

# TNRS file names
tnrs_submitted_filename="tnrs_submitted.csv"	# File uploaded to TNRS
tnrs_scrubbed_filename="tnrs_submitted_scrubbed.tsv"	# Name resolution results

#tnrs_submitted_filename="testfile"	# File uploaded to TNRS
#tnrs_scrubbed_filename="testfile_scrubbed.txt"	# Name resolution results

# Absolute path to data directory
# Set this value to absolute path if you wish to keep outside
# of top-level application directory. Otherwise, if you comment
# out or do not use an absolute path (ie., starting with '/')
# then this value will be ignored and relative path inside main
# application directory will be used
data_dir_local_abs=$tnrs_data_dir

# Set default development schema
dev_schema=$dev_schema_adb_private

# Batch size
# Generall 10000 works best for large files
# Eventually should set this dynamically by counting lines in input file
tnrs_batchsize=10000

# Set process names
pname_1="TNRSbatch 1: prepare names"
pname_2="TNRSbatch 2: scrub names"
pname_3="TNRSbatch 3: import results"

# Short name for each operation, for screen echo and 
# notification emails
# Variable pname, must be set to one of these in the calling script
pname_local=pname_1

# General process name prefix for email notifications
pname_local_header="BIEN notification: process '"$pname_local"'"

# Main db on which operation will be performed
# For display in messages and mails only
db_main=$db_private
