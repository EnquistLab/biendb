#!/bin/bash

##############################################################
# Application parameters
# Check and change as needed
##############################################################

# Extracted file names
dd_file_tables="dd_tables.csv"	# Tables definitions
dd_file_cols="dd_cols.csv"		# Column definitions
dd_file_vals="dd_vals.csv"		# Constrained value definitions

# Revised file names
dd_file_tables_revised="dd_tables_revised.csv"	# Tables definitions
dd_file_cols_revised="dd_cols_revised.csv"		# Column definitions
dd_file_vals_revised="dd_vals_revised.csv"		# Constrained value definitions

# Data directory
# Use relative path for this application
# Omit trailing slash
data_dir_local_abs="/home/boyle/bien3/analytical_db/private/data/data_dictionary"

# Set default development schema
dev_schema=$dev_schema_adb_private

# Set process names, for notification and screen echo,
# depending on which is being run
if [ "$local_basename" == "data_dictionary_1_create" ]; then
	pname_local="Data dictionary Step 1 - extract CSVs"
elif [ "$local_basename" == "data_dictionary_1_create_resume" ]; then
	pname_local="Data dictionary Step 1 - extract CSVs (resume)"
elif [ "$local_basename" == "data_dictionary_2_update" ]; then
	pname_local="Data dictionary Step 2 - update"
else
	echo "ERROR: Missing process name, check params file"; exit 1
fi

# General process name prefix for email notifications
pname_local_header="BIEN notification: process '"$pname_local"'"
# Main db on which operation will be performed
# For display in messages and mails only
db_main=$db_private
