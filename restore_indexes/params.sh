#!/bin/bash

##############################################################
# Application parameters
# Check and change as needed
##############################################################

# Short name for this operation, for screen echo and 
# notification emails
pname_local="Restore all indexes"

# General process name prefix for email notifications
pname_local_header="BIEN notification: process '"$pname_local"'"

# Main db on which operation will be performed
# For display in messages and mails only
db_main=$db_private
db=$db_main

# Schema
sch="analytical_db"