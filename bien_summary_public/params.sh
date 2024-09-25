#!/bin/bash

##############################################################
# Application parameters
# Check and change as needed
##############################################################

# production and development schemas for anaytical db
prod_schema=$prod_schema_adb_public
dev_schema=$dev_schema_adb_public

# Set true to force creation of new table, even if it already exists
force_create="false"

# Short name for this operation, for screen echo and 
# notification emails
pname_local="BIEN Summary Public"

# General process name prefix for email notifications
pname_local_header="BIEN notification: process '"$pname_local"'"

# Main db on which operation will be performed
# For display in messages and mails only
db_main=$db_private