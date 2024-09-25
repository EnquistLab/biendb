#!/bin/bash

##############################################################
# Application parameters
# Check and change as needed
##############################################################

# Path to local data directory
# If directory is outside app working directory, supply
# absolute path, otherwise supply relative path
# Recommend keeping outside app directory
# Omit trailing slash
local_data_path="/home/boyle/bien3/analytical_db/private/data"

# Set schema to use
dev_schema=$dev_schema_adb_private

# Short name for this operation, for screen echo and 
# notification emails
pname_local="Temp Fixes"

# General process name prefix for email notifications
pname_local_header="BIEN notification: process "$pname_local

# Main db on which operation will be performed
# For display in messages and mails only
db_main=$db_private