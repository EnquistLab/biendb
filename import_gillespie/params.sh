#!/bin/bash

##############################################################
# Application parameters
# Check and change as needed
# Parameter $src passed from master script
##############################################################

# Number of dbh fields, positive integer , no quotes
# For SALVIAS-format raw plot data, dbh measurements are all on the 
# same line as the individual observations, and fields are named 
# as follows: dbh1, dbh2, dbh3, ... , dbh[dbhflds]
dbhflds=15

# Names of raw data files
# List one per line, in same order as destination raw data tables 
# below. Do note surround with quotes. NO spaces in names
files_raw="
gillespie_people_unix.csv
gillespie_plot_descriptions_unix.csv
gillespie_plot_data_unix.csv
"

# Names of destination raw data tables, minus the '$src'_ prefix
# List one per line, MUST be in same order as raw files above
tbls_raw="
people
plot_descriptions
plot_data
"

# Name of metadata file
metadata_raw="datasource_metadata.csv"

# Determines method of joining to datasource when loading from
# staging table to main vfoi table
use_datasource_staging_id="f"

# Absolute path to data directory
# Set this value to absolute path if you wish to keep outside
# of top-level application directory. Otherwise, if you comment
# out or do not use an absolute path (ie., starting with '/')
# then this value will be ignored and relative path inside main
# application directory will be used
data_dir_local_abs="/home/boyle/bien3/data/"$src

# production and development schemas for anaytical db
prod_schema=$prod_schema_adb_private
dev_schema=$dev_schema_adb_private

# Short name for this operation, for screen echo and 
# notification emails
pname_local="Import "$src

# General process name prefix for email notifications
pname_local_header="BIEN notification: process '"$pname_local"'"

# Main db on which operation will be performed
# For display in messages and mails only
db_main=$db_private
