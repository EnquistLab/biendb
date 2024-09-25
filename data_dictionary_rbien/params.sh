#!/bin/bash

##############################################################
# Application parameters
# Check and change as needed
##############################################################

# Input files
inputfile="data_dictionary_rbien.xls"
inputfile_csv="data_dictionary_rbien.csv"

# target schema
schema=$dev_schema

# Absolute path to data directory
# Set this value to absolute path if you wish to keep outside
# of top-level application directory. Otherwise, if you comment
# out or do not use an absolute path (ie., starting with '/')
# then this value will be ignored and relative path inside main
# application directory will be used
#data_dir_local_abs="/home/boyle/bien3/analytical_db/private/data/data_dictionary_rbien"
data_dir_local_abs="/home/boyle/bien3/data/data_dictionary_rbien"

# Short name for this operation, for screen echo and 
# notification emails
pname_local="RBien data dictionary"

# General process name prefix for email notifications
pname_local_header="BIEN notification: process '"$pname_local"'"

# Main db on which operation will be performed
# For display in messages and mails only
db_main=$db_private



