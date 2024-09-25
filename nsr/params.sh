#!/bin/bash

# Precede temporary changes with thi message in case forget to remove
# echo "WARNING: Temporary changes to params for nsr_3_update.sh!"

##############################################################
# Application parameters
# Check and change as needed
##############################################################

# Replace NSR cache?
# Should be set to false, unless the NSR database has changed
# If set to true, scrubbing will take a lot longer as names
# must be check from scratch and the cache rebuilt
local_nsr_cache_replace=$NSR_CACHE_REPLACE


# Input/output file names
today=$(date +"%Y-%m-%d")
submitted_basename="bien_nsr_${today}"
submitted_filename="${submitted_basename}.csv"					# Input file
results_filename="${submitted_basename}_nsr_results.txt"	# Results file



# TEMPORARY CHANGE ONLY! BIEN 4.2
echo "WARNING: Temporary changes to params for nsr_3_update.sh!"
submitted_filename="bien_nsr_2021-02-22.csv"					# Input file
results_filename="bien_nsr_2021-02-22_nsr_results.txt"	# Results file

# submitted_filename="bien_adbtest_nsr_2021-01-26.csv"					# Input file
# results_filename="bien_adbtest_nsr_2021-01-26_nsr_results.txt"	# Results file



# Absolute path to data directory
# Set this value to absolute path if you wish to keep outside
# of top-level application directory. Otherwise, if you comment
# out or do not use an absolute path (ie., starting with '/')
# then this value will be ignored and relative path inside main
# application directory will be used
validation_app_data_dir=$NSR_DATA_DIR

# Absolute path to validation application directory
# Set this value to absolute path if you wish to keep outside
# of top-level application directory. Otherwise, if you comment
# out or do not use an absolute path (ie., starting with '/')
# then this value will be ignored and relative path inside main
# application directory will be used
app_dir=$NSR_DIR

# Set default development schema
dev_schema=$dev_schema_adb_private

# Set process names
pname_1="NSR: prepare extract"
pname_2="NSR: import results"

# Short name for each operation, for screen echo and 
# notification emails
# Variable pname, must be set to one of these in the calling script
pname_local=pname_1

# General process name prefix for email notifications
pname_local_header="BIEN notification: process '"$pname_local"'"

# Main db on which operation will be performed
# For display in messages and mails only
db_main=$db_private