#!/bin/bash

#########################################################################
# Purpose: Updates database version in public and private databases. 
#
# Details: 
#	Retires current version by populating bien_metadata.db_retired_date
# 	with current date. New version number set in local params file.
#
# Notes:
#	$dbv_db, $dbv_user, $dbv_sch, $db_to_update, &db_to_update_user,
#	$sch_to_update set in local params file, NOT in global params!
#
# Authors: Brad Boyle (bboyle@email.arizona.edu)
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
	suppress_main='true'
else
	suppress_main='false'
fi

# Load startup script for local files
# Sets remaining parameters and options, and issues confirmation
# and startup messages
source "$DIR/includes/startup_local.sh"	

######################################################
# Custom confirmation message
# Will only be displayed if running as standalone 
# script and -s (silent) option not used.
######################################################

# Current version retirement date is today
ret_date=`date +%Y-%m-%d`

# Get current version number from private database
db_ver_curr=`psql -d $BIEN_METADATA_DBV_DB -U $BIEN_METADATA_DBV_USER -t -c "SELECT db_version FROM ${BIEN_METADATA_DBV_SCH}.bien_metadata WHERE bien_metadata_id=(SELECT MAX(bien_metadata_id) FROM ${BIEN_METADATA_DBV_SCH}.bien_metadata)"`
db_ver_curr="$(trim "${db_ver_curr}")"

# Get new database version
db_ver_new=$BIEN_METADATA_DB_VERSION_NEW

if [[ "$i" = "true" ]]; then 
	# Reset confirmation message
	msg_conf="$(cat <<-EOF
	
	Update db version for the following databases:
	
	Current version:	$db_ver_curr
	Retirement date:	$ret_date
	New version:		$db_ver_new
	New ver. comments:	'$BIEN_METADATA_VERSION_COMMENTS'
	New DB code ver.:	$BIEN_METADATA_DB_CODE_VERSION
	Database:		$BIEN_METADATA_DB_TO_UPDATE
	Schema:			$BIEN_METADATA_SCH_TO_UPDATE
EOF
	)"		
	confirm "$msg_conf"
fi
	
#########################################################################
# Main
#########################################################################

echoi $e "Executing module '$local_basename'"

# Insert record for the new db version & retire previous
echoi $e -n "- Re-setting sequence for primary key..."
PGOPTIONS='--client-min-messages=warning' psql -U $BIEN_METADATA_DB_TO_UPDATE_USER -d $BIEN_METADATA_DB_TO_UPDATE --set ON_ERROR_STOP=1 -q -v sch=$BIEN_METADATA_SCH_TO_UPDATE -f $DIR_LOCAL/sql/bien_metadata_add_seq.sql  > /dev/null >> $tmplog
source "$DIR/includes/check_status.sh"	

# Insert record for the new db version & retire previous
echoi $e -n "- Inserting new record..."
PGOPTIONS='--client-min-messages=warning' psql -U $BIEN_METADATA_DB_TO_UPDATE_USER -d $BIEN_METADATA_DB_TO_UPDATE --set ON_ERROR_STOP=1 -q -v sch=$BIEN_METADATA_SCH_TO_UPDATE -v db_version="$db_ver_new" -v version_comments="$BIEN_METADATA_VERSION_COMMENTS" -v db_code_version="$BIEN_METADATA_DB_CODE_VERSION" -v rbien_version="$BIEN_METADATA_RBIEN_VERSION" -v rtodobien_version="$BIEN_METADATA_RTODOBIEN_VERSION" -v tnrs_version="$BIEN_METADATA_TNRS_VERSION" -f $DIR_LOCAL/sql/update_version.sql
source "$DIR/includes/check_status.sh"	

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi
