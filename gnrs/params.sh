#!/bin/bash

##############################################################
# Application parameters
# Check and change as needed
##############################################################

# GNRS file names
submitted_filename="gnrs_submitted_bien.csv"	# Validation input file
results_filename="gnrs_submitted_bien_scrubbed.tsv"		# Validation results file

##########################
# Results file import parameters
##########################
# values: ","|"E'\t'"
results_file_delim="E'\t'"

# values: "HEADER"|""
results_file_header="HEADER"

# Absolute path to data directory
# Set this value to absolute path if you wish to keep outside
# of top-level application directory. Otherwise, if you comment
# out or do not use an absolute path (ie., starting with '/')
# then this value will be ignored and relative path inside main
# application directory will be used
validation_app_data_dir=$gnrs_data_dir	# Defined in main app dir
data_dir_local=$validation_app_data_dir	# Don't ask; backward compatibility

# Set default development schema
dev_schema=$dev_schema_adb_private

# Set process names
pname_1="GNRS"
pname_2="GNRS: import results"

# Short name for each operation, for screen echo and 
# notification emails
# Variable pname, must be set to one of these in the calling script
pname_local=pname_1

# General process name prefix for email notifications
pname_local_header="BIEN notification: process '"$pname_local"'"

# Main db on which operation will be performed
# For display in messages and mails only
db_main=$db_private
