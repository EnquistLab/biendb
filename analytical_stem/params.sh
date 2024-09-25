#!/bin/bash

##############################################################
# Application parameters
# Check and change as needed
##############################################################

# Set default development schema
dev_schema=$dev_schema_adb_private

# Short name for each operation, for screen echo and 
# notification emails
# Variable pname, must be set to one of these in the calling script
pname_local="Analytical Stem"

# General process name prefix for email notifications
pname_local_header="BIEN notification: process '"$pname_local"'"

# Main db on which operation will be performed
# For display in messages and mails only
db_main=$db_private
