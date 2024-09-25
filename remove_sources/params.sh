#!/bin/bash

##############################################################
# Application parameters
# Check and change as needed
##############################################################

# Set process names, for notification and screen echo,
# depending on which is being run
if [ "$local_basename" == "remove_duplicate_sources" ]; then
	pname_local="Remove duplicate sources"
elif [ "$local_basename" == "remove_secondary_sources" ]; then
	pname_local="Remove secondary sources"
else
	echo "ERROR: Missing process name, check params file"; exit 1
fi

# General process name prefix for email notifications
pname_local_header="BIEN notification: process '"$pname_local"'"
# Main db on which operation will be performed
# For display in messages and mails only
db_main=$db_private
