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
today=$(date +"%Y-%m-%d")
submitted_filename_prox="bien_cods_prox_${today}.csv"	# Proximity input 
submitted_filename_desc="bien_cods_desc_${today}.csv"	# Description input file
results_filename_prox="bien_cods_prox_${today}_scrubbed.csv" # Proximity results 
results_filename_desc="bien_cods_desc_${today}_scrubbed.csv" # Descr. results

# TEMPORARY CHANGE ONLY! BIEN 4.2
echo "WARNING: Temporary changes to params for cods_3_update.sh!"
submitted_filename_prox="cods_prox_submitted.csv"	# Proximity input 
submitted_filename_desc="cods_desc_submitted.csv"	# Description input file
results_filename_prox="cods_prox_submitted_cods_results.csv" # Proximity results 
results_filename_desc="cods_desc_submitted_cods_results.csv" # Descr. results



# Absolute path to validation application directory
# Omit trailing /
validation_app_dir=$CODS_DIR

# Absolute path to validation application directory
# Omit trailing /
validation_app_data_dir=$CODS_DATA_DIR
data_dir_local_abs=$validation_app_data_dir

# Set default development schema
dev_schema=$dev_schema_adb_private

# Set process names, for notification and screen echo,
# depending on which is being run
if [ "$local_basename" == "cods_1_prepare" ]; then
	pname_local="CULTOBS Step 1 - extract observations"
elif [ "$local_basename" == "cods_2_scrub" ]; then
	pname_local="CULTOBS Step 2 - scrub observations"
elif [ "$local_basename" == "cods_3_update" ]; then
	pname_local="CULTOBS Step 3 - update observations"
else
	echo "ERROR: Missing process name, check params file"; exit 1
fi

# General process name prefix for email notifications
pname_local_header="BIEN notification: process '"$pname_local"'"
# Main db on which operation will be performed
# For display in messages and mails only
db_main=$db_private
