#!/bin/bash

#########################################################################
# Purpose: Remove completely from legacy tables sources that will be 
#	imported from scratch later in pipeline
#
# Authors: Brad Boyle (bboyle@email.arizona.edu)
#########################################################################

: <<'COMMENT_BLOCK_x'
COMMENT_BLOCK_x
#echo "EXITING script `basename "$BASH_SOURCE"`"; exit 0

######################################################
# Set parameters, load functions & confirm operation
# 
# Loads only local parameters if called by master script.
# Otherwise loads all parameters, functions and options
# Local parameters $db and $sch used ONLY if
# running along, not called by master script
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

############################################
# Form list of sources for to remove, also
# used for sql
############################################

# Form SQL of source codes
src_list=""
for dup_src in $dup_sources; do
	src_list=$src_list"'"$dup_src"',"
done
src_list="${src_list::-1}"

######################################################
# Custom confirmation message. 
# Will only be displayed if running standalone 
# and -s (silent) option not used.
######################################################

if [[ "$i" = "true" && -z ${master+x} ]]; then 

	# Reset confirmation message
	msg_conf="$(cat <<-EOF

	Run process '$pname' with following options:
	
	Database:		$db_private
	Schema:			$dev_schema
	Sources:		$src_list
		
EOF
	)"		
	confirm "$msg_conf"
fi

if [ -z ${db_private+x} ] || [ -z ${dev_schema+x} ]; then
	echo "ERROR: Missing database and/or schema!"; exit 1;
fi
	
#########################################################################
# Main
#########################################################################

echoi $e "Executing module '$local_basename'"

############################################
# Delete the source records
############################################

echoi $e "- Removing duplicate sources:"

echoi $e -n "- Adding indexes..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema_adb_private -f $DIR_LOCAL/sql/drop_indexes.sql
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema_adb_private -f $DIR_LOCAL/sql/index_datasource.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Removing duplicate sources..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema_adb_private -v src_list="$src_list" -f $DIR_LOCAL/sql/remove_duplicate_sources.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Dropping indexes..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema_adb_private -f $DIR_LOCAL/sql/drop_indexes.sql
source "$DIR/includes/check_status.sh"	

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [[ "$i" = "true" && -z ${master+x} ]]; then 
source "$DIR/includes/finish.sh"; fi