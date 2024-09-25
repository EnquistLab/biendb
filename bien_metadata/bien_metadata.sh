#!/bin/bash

#########################################################################
# Purpose: Adds column observation_type to table vfoi
#
# Authors: Brad Boyle (bboyle@email.arizona.edu)
# Date created: 25 Nov. 2016
# Date first release: 
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

# Set parent directory if running independently & suppress main message
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

tbl_exists=$(exists_table_psql -d $db_private -u $user -s $prod_schema_adb_private -t 'bien_metadata' )

# if table already exists in production schema, copy it
if [[ $tbl_exists == "t" && $BIEN_METADATA_REPLACE_TABLE == "true" ]]; then
	echoi $e -n "- Copying table bien_metadata from production schema..."
	PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$BIEN_METADATA_DEV_SCHEMA -v prod_schema=$prod_schema_adb_private -f $DIR_LOCAL/sql/copy_previous.sql > /dev/null >> $tmplog
	source "$DIR/includes/check_status.sh"	
else
	# Create new empty table
	echoi $e -n "- Creating table bien_metadata..."
	PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$BIEN_METADATA_DEV_SCHEMA -f $DIR_LOCAL/sql/create_bien_metadata.sql
	source "$DIR/includes/check_status.sh"	
fi

# Insert record for the new db version
if [[ $BIEN_METADATA_INSERT_NEW == "true" ]]; then
	echoi $e -n "- Inserting new record..."
	PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$BIEN_METADATA_DEV_SCHEMA -v db_version="$BIEN_METADATA_DB_VERSION_NEW" -v version_comments="$BIEN_METADATA_VERSION_COMMENTS" -v db_code_version="$BIEN_METADATA_DB_CODE_VERSION" -v rbien_version="$BIEN_METADATA_RBIEN_VERSION" -v rtodobien_version="$BIEN_METADATA_RTODOBIEN_VERSION" -v tnrs_version="$BIEN_METADATA_TNRS_VERSION" -f $DIR_LOCAL/sql/update_version.sql
	source "$DIR/includes/check_status.sh"	
fi

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi


