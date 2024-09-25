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
if [[ $tbl_exists == "t" && $replace_table == "true" ]]; then
	echoi $e -n "- Copying table bien_metadata from production schema..."
	PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -v prod_schema=$prod_schema_adb_private -f $DIR_LOCAL/sql/copy_previous.sql > /dev/null >> $tmplog
	source "$DIR/includes/check_status.sh"	
else
	# Create new empty table
	echoi $e -n "- Creating table bien_metadata..."
	PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/create_bien_metadata.sql
	source "$DIR/includes/check_status.sh"	
fi


echoi $e -n "- Adding column tnrs_version to table bien_metadata..."
sql="
ALTER TABLE bien_metadata ADD COLUMN tnrs_version TEXT DEFAULT NULL;
CREATE INDEX bien_metadata_tnrs_version_idx ON bien_metadata (tnrs_version);
"
PGOPTIONS='--client-min-messages=warning' psql $db_private $user -q << EOF
\set ON_ERROR_STOP on
SET search_path TO $dev_schema;
$sql
EOF
source "$DIR/includes/check_status.sh"	




# Insert record for the new db version
if [[ $insert_new == "true" ]]; then
	echoi $e -n "- Inserting new record..."
	PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -v db_version="$db_version" -v version_comments="$version_comments" -v db_code_version="$db_code_version" -v rbien_version="$rbien_version" -v rtodobien_version="$rtodobien_version" -v tnrs_version="$tnrs_version" -f $DIR_LOCAL/sql/update_version.sql
	source "$DIR/includes/check_status.sh"	
fi

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi


