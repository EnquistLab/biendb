#!/bin/bash

#########################################################################
# Purpose: Updates analytical table datasource from spreadsheet, imported
#	as CSV file
#
# Usage: 
#		$ ./update_datasource.sh [options]
#  
# Requires:
# 	CSV file $update_file in data folder. This file created as 
#	intermediate step in create_datasource.sh. Verbatim extract of
#	table datasource. Fill in missing information manually and use
#	this script to update the production table, datasource.
#
# Gotcha:
#	File $update_file MUST be UTF-8 with UNIX-style line endings.
#
# Authors: Brad Boyle (bboyle@email.arizona.edu)
# Date created: 10 Feb. 2017
# First release: 10 Feb. 2017
# Database version at first release: 3.4.2
#########################################################################

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

#########################################################################
# Main
#########################################################################

echoi $e "Executing module '$local_basename'"

######################################################
# backup old table before updating 
######################################################

#tbl_datasource_bak="datasource_bak_$(date +%Y%m%d_%H%M%S)"
tbl_datasource_bak="datasource_bak"
#echo $tbl_datasource_bak

if [ "$backup_datasource" == "true" ]; then
	echoi $i -n "- Backing up table datasource as $tbl_datasource_bak in schema $dev_schema..."
	sql="
	DROP TABLE IF EXISTS ${dev_schema}.${tbl_datasource_bak};
	CREATE TABLE ${dev_schema}.${tbl_datasource_bak} ( LIKE ${src_schema}.datasource INCLUDING DEFAULTS INCLUDING CONSTRAINTS INCLUDING INDEXES );
	INSERT INTO ${dev_schema}.${tbl_datasource_bak} SELECT * FROM ${src_schema}.datasource;
	"
	PGOPTIONS='--client-min-messages=warning' psql $db_private $user -q << EOF
	\set ON_ERROR_STOP on
	SET search_path TO $dev_schema;
	$sql
EOF
	source "$DIR/includes/check_status.sh"	
fi

# Create datasource_update, an empty copy of table datasource
echoi $i -n "- Creating table datasource_update..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/create_datasource_update.sql
source "$DIR/includes/check_status.sh"	

echoi $i -n "- Importing datasource revisions file..."
# sql="
# \COPY datasource_update FROM '${data_dir_local}/${update_file}' CSV HEADER DELIMITER E'\t';
# "
sql="
\COPY datasource_update FROM '${data_dir_local}/${update_file}' CSV HEADER;
"
PGOPTIONS='--client-min-messages=warning' psql $db_private $user -q << EOF
\set ON_ERROR_STOP on
SET search_path TO $dev_schema;
$sql
EOF
source "$DIR/includes/check_status.sh"	

# Update the table by joining on PK, substituting contents of all
# columns from the imported spreadsheet
echoi $i -n "- Updating datasource..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/update_datasource.sql
source "$DIR/includes/check_status.sh"	

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi

######################################################
# End script
######################################################

