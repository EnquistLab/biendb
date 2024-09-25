#!/bin/bash

##############################################################
# Application parameters
# Check and change as needed
##############################################################

# Development schema where tables will be created
target_sch=$dev_schema_adb_private	

# Absolute path to data directory
# Set this value to absolute path if you wish to keep outside
# of top-level application directory. Otherwise, if you comment
# out or do not use an absolute path (ie., starting with '/')
# then this value will be ignored and relative path inside main
# application directory will be used
data_dir_local_abs="/home/boyle/bien3/analytical_db/private/data/"

# Short name for each operation, for screen echo and 
# notification emails
# Variable pname, must be set to one of these in the calling script
pname_local="Political division tables" 

# Main db on which operation will be performed
# For display in messages and mails only
db_main=$db_private
