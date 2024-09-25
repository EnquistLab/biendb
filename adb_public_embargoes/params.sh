#!/bin/bash

##############################################################
# Application parameters
# Check and change as needed
##############################################################

# Schema on which operation will be performed
dev_schema=$dev_schema_adb_public

# Minimum species/trait threshold
# Traits with less than this number will be deleted from
# public database
sp_count_min=300

# Short name for this operation, for screen echo and 
# notification emails
pname_local="ADB public embargoes"

# General process name prefix for email notifications
pname_local_header="BIEN notification: process '"$pname_local"'"

# Main db on which operation will be performed
# For display in messages and mails only
db_main=$db_public