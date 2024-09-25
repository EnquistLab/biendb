#!/bin/bash

##############################################################
# Application parameters
# Check and change as needed
##############################################################

# Datasource files, for export, manual editing and import
# Will be saved to local data directory
#update_file="datasource_11_18_2016.csv"
#update_file="datasource_11_18_2016_take2.csv"
update_file="datasource_2_22_2017_utf8.csv"

# Set to 'true' to backup original datasource table if updating
# existing table
backup='true'

# Absolute path to data directory
# Set this value to absolute path if you wish to keep outside
# of top-level application directory. Otherwise, if you comment
# out or do not use an absolute path (ie., starting with '/')
# then this value will be ignored and relative path inside main
# application directory will be used
data_dir_local_abs="/home/boyle/bien3/analytical_db/private/data/update_datasource"

# Set default development schema
dev_schema=$dev_schema_adb_private

# Set source schema (for updating onlyP
src_schema=$dev_schema_adb_private

# Short name for each operation, for screen echo and 
# notification emails
# Variable pname, must be set to one of these in the calling script
pname_local="Update datasource"

# General process name prefix for email notifications
pname_local_header="BIEN notification: process '"$pname_local"'"

# Main db on which operation will be performed
# For display in messages and mails only
db_main=$db_private
