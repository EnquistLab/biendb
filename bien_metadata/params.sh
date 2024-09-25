#!/bin/bash

##############################################################
# Application parameters
# Check and change as needed
##############################################################

# Short name for this operation, for screen echo and 
# notification emails
pname_local="BIEN Metadata"

# Set process names, for notification and screen echo,
# depending on which is being run
if [ "$local_basename" == "bien_metadata" ]; then
	pname_local="Create/update table bien_metadata"
elif [ "$local_basename" == "db_version_update" ]; then
	pname_local="Update database version"
elif [ "$local_basename" == "bien_metadata_custom_bien4.1" ]; then
	pname_local="Create/update table bien_metadata"
else
	pname_local="$local_basename"
fi

# General process name prefix for email notifications
pname_local_header="BIEN notification: process '"$pname_local"'"

# Main db on which operation will be performed
# For display in messages and mails only
db_main=$db_private