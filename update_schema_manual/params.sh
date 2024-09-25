#!/bin/bash

##############################################################
# Application parameters
# Check and change as needed
##############################################################

# Set target development schema
dev_schema="analytical_db_dev2"

# Set process names, for notification and screen echo,
# depending on which is being run
if [ $local_basename = "update_schema_vfoi" ]; then
	pname_local="Update schema manual: vfoi"
elif [ $local_basename = "update_schema_astem" ]; then
	pname_local="Update schema manual: analytical_stem"
elif [ $local_basename = "update_schema_agg_traits" ]; then
	pname_local="Update schema manual: agg_traits"
elif [ $local_basename = "update_schema_all" ]; then
	pname_local="Update schema manual: update all"
else
	echo "ERROR: Missing process name, check params file"; exit 1
fi

# General process name prefix for email notifications
pname_local_header="BIEN notification: process '"$pname_local"'"

# Main db on which operation will be performed
# For display in messages and mails only
db_main=$db_private