#!/bin/bash

##############################################################
# Application parameters
# Check and change as needed
##############################################################

# Minimum distance to herbarium, in km
# Observations this close or closer will be marked is_cultivated=1
HERB_MIN_DIST=3

# Number of observation per batch
BATCHSIZE=100000

# Input/output file names
submitted_filename="cultobs_submitted.csv"	# Validation input file
results_filename="cultobs_results.csv"		# Validation results file

# Absolute path to validation application directory
# Omit trailing /
validation_app_dir="/home/boyle/bien3/repos/cultobs"

# Absolute path to validation application directory
# Omit trailing /
validation_app_data_dir="/home/boyle/bien3/cultobs/userdata"

# Data directory
# Use relative path for this application
# Omit trailing slash
data_dir_local_abs="data"

# Set default development schema
dev_schema=$dev_schema_adb_private

# Set process names, for notification and screen echo,
# depending on which is being run
if [ "$local_basename" == "cultobs_1_prepare" ]; then
	pname_local="CULTOBS Step 1 - extract observations"
elif [ "$local_basename" == "cultobs_2_scrub" ]; then
	pname_local="CULTOBS Step 2 - scrub observations"
elif [ "$local_basename" == "cultobs_3_update" ]; then
	pname_local="CULTOBS Step 3 - update observations"
elif [ "$local_basename" == "cultobs_1_prepare_TEMP_restart" ]; then
	pname_local="CULTOBS Step 1 - extract observations (resume)"
else
	echo "ERROR: Missing process name, check params file"; exit 1
fi

# General process name prefix for email notifications
pname_local_header="BIEN notification: process '"$pname_local"'"
# Main db on which operation will be performed
# For display in messages and mails only
db_main=$db_private
