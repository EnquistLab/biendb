#!/bin/bash

##############################################################
# Application parameters
# Check and change as needed
##############################################################

# Absolute path to data directory
# Set this value to absolute path if you wish to keep outside
# of top-level application directory. Otherwise, if you comment
# out or do not use an absolute path (ie., starting with '/')
# then this value will be ignored and relative path inside main
# application directory will be used
data_dir_local_abs="/home/boyle/bien3/analytical_db/private/data/datasource"

# Datasource files, for export, manual editing and import
# Will be saved to local data directory
datasource_file="datasource.tsv"
update_file="datasource_revised.csv"

# Set to true to save a copy of table datasource as datasource_bak
backup_datasource='true'

# Set to 'true' to import update file immediately while running  
# script create_datasource.sh.
# Assumes create_datasource.sh has already been run once, and  
# $datasource_file updated manually and saved to local data folder 
# as $update_file. $update_file MUST exist!
apply_update='true'

# Set default development schema
dev_schema=$dev_schema_adb_private

# Set source schema (for updating onlyP
src_schema=$dev_schema_adb_private

# Set process names, for notification and screen echo,
# depending on which is being run
if [ "$local_basename" == "datasource_1_load_legacy" ]; then
	pname_local="Datasource Step 1 - load legacy sources"
elif [ "$local_basename" == "datasource_2_export" ]; then
	pname_local="Datasource Step 2 - export datasource"
elif [ "$local_basename" == "datasource_3_update" ]; then
	pname_local="Datasource Step 3 - update datasource"
else
	echo "ERROR: Missing process name, check params file"; exit 1
fi

# General process name prefix for email notifications
pname_local_header="BIEN notification: process '"$pname_local"'"

# Main db on which operation will be performed
# For display in messages and mails only
db_main=$db_private


