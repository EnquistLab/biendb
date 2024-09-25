#!/bin/bash

##############################################################
# Application parameters
# Check and change as needed
##############################################################

# Datasource-specific plot metadata files
meta_file_cvs="bradBoyle_CVS_metadata.csv"
meta_file_vegbank="temp_bb_vegbank_metadata2.txt"
meta_file_bien2="bien2_plot_metadata.txt"
meta_file_general="general_metadata.csv"

# Absolute path to data directory
# Set this value to absolute path if you wish to keep outside
# of top-level application directory. Otherwise, if you comment
# out or do not use an absolute path (ie., starting with '/')
# then this value will be ignored and relative path inside main
# application directory will be used
data_dir_local_abs="/home/boyle/bien3/analytical_db/private/data/plot_metadata"

# Set default development schema for this operation
# Variable on right is inherited from master params file
dev_schema=$dev_schema_adb_private

# Short name for this operation, for screen echo and 
# notification emails
pname_local="Plot metadata"

# General process name prefix for email notifications
pname_local_header="BIEN notification: process '"$pname_local"'"

# Main db on which operation will be performed
# For display in messages and mails only
db_main=$db_private



