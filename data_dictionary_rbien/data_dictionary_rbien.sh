#!/bin/bash

#########################################################################
# Purpose: Create & populates table data_dictionary_rbien
#
# Usage: 
#		$ ./data_dictionary_rbien.sh [options]
#  
# Warnings:
# 	1. Requires input spreadsheet data_dictionary_rbien.xls
# 	2. Not part of pipeline. Use to add or update data dictionary
#		table to complete analytical database.
#
# Authors: Brad Boyle (bboyle@email.arizona.edu)
# Date created: 17 Sept. 2016
# First release: 
# Database version at first release: 
#########################################################################

# Wrap any section you do not want to run in comment blocks. 
# Additional comment wrappers must have different comment
# block name, e.g., COMMENT_BLOCK_2
: <<'COMMENT_BLOCK_1'
COMMENT_BLOCK_1

######################################################
# Set parameters, load functions & confirm operation
# 
# Loads local parameters only if called by master script.
# Otherwise loads all parameters, functions and options
######################################################

# Get local working directory
DIR_LOCAL="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR_LOCAL" ]]; then DIR_LOCAL="$PWD"; fi

# $local = name of this file
# $local_basename = name of this file minus ='.sh' extension
# $local_basename should be same as containing directory, as  
# well as local data subdirectory within main data directory, 
# if local data directory needed
local=`basename "${BASH_SOURCE[0]}"`
local_basename="${local/.sh/}"

# Set parent directory if running independently
if [ -z ${master+x} ]; then
	DIR=$DIR_LOCAL"/.."
fi

# Load startup script for local files
# Sets remaining parameters and options, and issues confirmation
# and startup messages
source "$DIR/includes/startup_local.sh"	

echoi $e "Executing module '$local_basename'"

#########################################################################
# Main
#########################################################################

# Create table data_dictionary_rbien
echoi $i -n "Creating table data_dictionary_rbien..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$schema -f $DIR_LOCAL/sql/create_data_dictionary_rbien.sql
source "$DIR/includes/check_status.sh"	

echoi $i -n "- Importing CSV..."
sql="
\COPY data_dictionary_rbien FROM '${data_dir_local}/${inputfile_csv}' DELIMITER ',' CSV HEADER;
"
PGOPTIONS='--client-min-messages=warning' psql $db_private $user -q << EOF
\set ON_ERROR_STOP on
SET search_path TO $schema;
$sql
EOF
source "$DIR/includes/check_status.sh"	

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi

######################################################
# End script
######################################################
