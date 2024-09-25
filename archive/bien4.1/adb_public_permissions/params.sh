#!/bin/bash

##############################################################
# Application parameters
# Check and change as needed
##############################################################

# Schema on which operation will be performed
dev_schema=$dev_schema_adb_public

# Short name for this operation, for screen echo and 
# notification emails
pname_local="ADB public restore indexes"

# General process name prefix for email notifications
pname_local_header="BIEN notification: process '"$pname_local"'"

# Main db on which operation will be performed
# For display in messages and mails only
db_main=$db_public