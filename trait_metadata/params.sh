#!/bin/bash

##############################################################
# Application parameters
# Check and change as needed
##############################################################

# Database and schema parameters
# Used only if running stand-alone and not called by 
# master script
if [ -z ${master+x} ]; then
	db=$db_private
	dev_schema=$dev_schema_adb_private
fi

# Short name for this operation, for screen echo and 
# notification emails
pname_local="Trait Metadata"

# General process name prefix for email notifications
pname_local_header="BIEN notification: process '"$pname_local"'"

# Main db on which operation will be performed
# For display in messages and mails only
db_main=$db_private