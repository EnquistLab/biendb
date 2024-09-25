#!/bin/bash

# Only two options. Comment out whichever doesn't apply
# full: backup entire database
# schema only: backup only the selected schema. You MUST
# supply a schema name if you choose this option
backup_type="schema only"
#backup_type="full"

# Database and schema to backup. 
# set sch="" if doing full backup
# db="vegbien"
# sch="analytical_db_4_1_1"
db="public_vegbien"
sch="public_4_0_3"

# Set true to include db version number in dumpfile name
# Database MUST have table "bien_metadata" to use this option,
# or set lookup_db_version="false" and use custom version
include_db_version="true"

# Get db version from database
# if true, then parameter $dbv_sch MUST be supplied
# Ignored if include_db_version="false"
# If false AND include_db_version="true", then MUST supply 
# parameter db_versionm (see below)
lookup_db_version="false"

# schema where db version table lives, if applicable
# May or may not be same as $sch
# Only applicable if include_db_version=true
dbv_sch=""

# Custom db version number to include in backup file name
# Can also include any other test you want to include in filename
# Unix-friendly only: no spaces or special characters!
# Ignored if include_db_version="false" or lookup_db_version="true"
db_version="4.0.3"

# Data directory in which dumpfile will be saved
# Set this value to absolute path if you wish to keep outside
# of top-level application directory. Otherwise, if you comment
# out or do not use an absolute path (ie., starting with '/')
# then this value will be ignored and relative path inside main
# application directory will be used
data_dir_local_abs="/home/bien/backups"

# Short name for this operation, for screen echo and 
# notification emails
if [ -z ${pname_custom+x} ]; then
	pname_local="Backup"
else
	pname_local="$pname_custom"
fi

# General process name prefix for email notifications
pname_local_header="BIEN notification: process '"$pname_local"'"

# Suppress generic local module message
suppress_main=true
