#!/bin/bash

##############################################################
# Application parameters
# Check and change as needed
##############################################################

# Schema on which operation will be performed 
# Not that name of dev schema will be same in private and public databases
dev_schema=$dev_schema_adb_private

# Absolute path to data directory
# Set this value to absolute path if you wish to keep outside
# of top-level application directory. Otherwise, if you comment
# out or do not use an absolute path (ie., starting with '/')
# then this value will be ignored and relative path inside main
# application directory will be used
data_dir_local_abs="/home/boyle/bien3/analytical_db/public"

# Short name for this operation, for screen echo and 
# notification emails
pname_local="world_geom"

# General process name prefix for email notifications
pname_local_header="BIEN notification: process '"$pname_local"'"
