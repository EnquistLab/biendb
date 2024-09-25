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
local_data_path="/home/boyle/bien3/analytical_db/private/"$app_dir"/data"

# Custom where clauses for legacy tables
# Use to remove old sources that will be reimported later
# Include " WHERE "
# To remove, set to empty string: ""
sql_where_vfoi=" WHERE datasource NOT IN ('Cyrille_traits','GBIF') "
#sql_where_vfoi=""
sql_where_astem=""
#sql_where_astem=" WHERE verbatim_scientific_name IS NOT NULL "

# Short name for this operation, for screen echo and 
# notification emails
pname_local="Copy Core Tables"

# General process name prefix for email notifications
pname_local_header="BIEN notification: process "$pname_local

# Main db on which operation will be performed
# For display in messages and mails only
db_main=$db_private