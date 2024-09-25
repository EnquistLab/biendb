#!/bin/bash

##############################################################
# Application parameters
# Check and change as needed
# Parameter $src passed from master script
##############################################################

# Absolute path to data directory
# Set this value to absolute path if you wish to keep outside
# of top-level application directory. Otherwise, if you comment
# out or do not use an absolute path (ie., starting with '/')
# then this value will be ignored and relative path inside main
# application directory will be used
data_dir_local_abs="/home/boyle/bien3/data/"$src

# Full name for this source
src_name="Atlas of Living Australia"

# Names of raw data file(s)
# recommend numbering: _raw, _raw1, _raw2
# All files must be in data directory for this source
data_raw="records-2017-08-31.csv"
metadata_raw="datasource_metadata.csv"

# production and development schemas for anaytical db
prod_schema=$prod_schema_adb_private
dev_schema=$dev_schema_adb_private

# Determines method of joining to datasource when loading from
# staging table to main vfoi table
use_datasource_staging_id="f"

# Short name for this operation, for screen echo and 
# notification emails
pname_local="Import '"$src"'"

# General process name prefix for email notifications
pname_local_header="BIEN notification: process '"$pname_local"'"

# Main db on which operation will be performed
# For display in messages and mails only
db_main=$db_private
