#!/bin/bash

##############################################################
# Application parameters
# Check and change as needed
##############################################################

# Database, schema and table name parameters
# Used only if running stand-alone and not called by 
# master script
if [ -z ${master+x} ]; then
	db=$db_private
	#dev_schema=$dev_schema_adb_private
	dev_schema=$prod_schema_adb_private
	#tbl_vfoi="view_full_occurrence_individual_dev"
	tbl_vfoi="view_full_occurrence_individual"
fi

# Set local limit for testing, if any
# set limit="" to turn off
limit=$sql_limit_global

# Set to true to update db version
# Another other value treated as false
# If true, you must set the next two db version parameters
update_db_verson="false"

# New db version to set after completing the operation
# Used only if running as standalone and update_db_verson="true"
db_version="3.4.5"
version_comments="Updated tables observations_union & species to global coverage & added to all databases"

# Absolute path to data directory
# Set this value to absolute path if you wish to keep outside
# of top-level application directory. Otherwise, if you comment
# out or do not use an absolute path (ie., starting with '/')
# then this value will be ignored and relative path inside main
# application directory will be used
data_dir_local_abs="/home/boyle/bien3/analytical_db/private/data/"

# Short name for each operation, for screen echo and 
# notification emails
# Variable pname, must be set to one of these in the calling script
pname_local="observations_union" 
pname_local_standalone="observations_union_standalone" 
pname_local_geombien="observations_union_geombien" 

# Main db on which operation will be performed
# For display in messages and mails only
if [ -z ${master+x} ]; then
	db_main=$db_private
fi
