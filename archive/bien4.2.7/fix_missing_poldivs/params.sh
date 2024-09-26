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
	curr_sch=$dev_schema_adb_private
else
	# Use default development db & schema parameters
	# if running in pipeline
	curr_db=$db_private
	curr_sch=$dev_schema_adb_private
fi

# Data directory absolute path
# Set this value to absolute path if you wish to keep outside
# of top-level application directory. Otherwise, if you comment
# out or do not use an absolute path (ie., starting with '/')
# then this value will be ignored and relative path inside main
# application directory will be used
data_dir_local_abs="/home/boyle/bien3/analytical_db/private/data/"

# Set process names, for notification and screen echo,
# depending on which is being run
if [ "$local_basename" == "fix_missing_poldivs_1" ]; then
	pname_local="Fix missing political divisions (CVS, Madidi, NVS)"
elif [ "$local_basename" == "fix_missing_poldivs_2" ]; then
	pname_local="Fix missing political divisions (TEAM)"
else
	echo "ERROR: Missing process name, check params file"; exit 1
fi


