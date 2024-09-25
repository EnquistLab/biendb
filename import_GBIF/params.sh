#!/bin/bash

##############################################################
# Application parameters
# Check and change as needed
# Parameter $src passed from master script
##############################################################

# Names of raw data file(s)
# recommend numbering: _raw, _raw1, _raw2
# All files must be in data directory for this source
#data_raw="gbif_raw_20180515.csv"
#data_raw="occurrence_sample.txt"
data_raw="occurrence_cleaned.txt"
#data_raw="occurrence.txt"
metadata_raw="datasource_metadata.csv"

# Name of main raw data table
# Normally should be $src"_raw" unless >1 table
# Requires param $src set by master script
# Note conversion to lowercase table name in case source name contains CAPS
tbl_raw=$src"_occurrence_raw"
tbl_raw=`echo "$tbl_raw" | tr '[:upper:]' '[:lower:]'`

# Name of verbatim original data table
# Need to import this as well to extract political divisions
#tbl_verbatim_raw=$src"_verbatim_raw"

# Determines method of joining to datasource when loading from
# staging table to main vfoi table
use_datasource_staging_id="t"

# Absolute path to data directory
# Set this value to absolute path if you wish to keep outside
# of top-level application directory. Otherwise, if you comment
# out or do not use an absolute path (ie., starting with '/')
# then this value will be ignored and relative path inside main
# application directory will be used
data_dir_local_abs="/home/boyle/bien3/data/"$src"/bien4.2"

# production and development schemas for anaytical db
prod_schema=$prod_schema_adb_private
dev_schema=$dev_schema_adb_private

# Set to true to import subsample of data only, otherwise false
# Will over-ride $use_local setting in main params file
# In turn, use_limit_local='false' is over-ridden if global
# parameter $force_limit='true'
use_limit_local='false'

# Short name for this operation, for screen echo and 
# notification emails
pname_local="Import "$src

# General process name prefix for email notifications
pname_local_header="BIEN notification: process '"$pname_local"'"

# Main db on which operation will be performed
# For display in messages and mails only
db_main=$db_private
