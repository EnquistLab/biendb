#!/bin/bash

##############################################################
# Application parameters
# Check and change as needed
##############################################################

# SQL script directory
hf_dir="sql"

# Set target database and schema
if [ -z ${master+x} ]; then
	# Use these parameters if running standalone
	#curr_db=$db_private
	#curr_sch=$prod_schema_adb_private
	curr_db=$db_private
	curr_sch=$prod_schema_adb_private
else
	# Use default development db & schema parameters
	# if running in pipeline
	curr_db=$db_private
	curr_sch=$dev_schema_adb_private
fi

# Record limit for testing only
# For production set to empty string ("") to remove limit
reclim=""

# Data directory absolute path
# Set this value to absolute path if you wish to keep outside
# of top-level application directory. Otherwise, if you comment
# out or do not use an absolute path (ie., starting with '/')
# then this value will be ignored and relative path inside main
# application directory will be used
data_dir_local_abs="/home/boyle/bien3/analytical_db/private/data/"

# Short name for each operation, for screen echo and 
# notification emails
# Variable pname, must be set to one of these in the calling script
pname_local="Fix FIA" 
