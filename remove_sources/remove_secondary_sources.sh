#!/bin/bash

#########################################################################
# Purpose: Remove secondary (redistributed) records of any primary 
#	sources that provide their data directly to BIEN. 
#
# Example: MO provides its specimen records directly to BIEN. We 
#	therefore remove all MO specimen records redistributed by other 
#	sources.
#
# Authors: Brad Boyle (bboyle@email.arizona.edu)
#########################################################################

# Comment-out code, if needed
# Runtime echo prevents temporary comment blocks from being "forgotten"

#### TEMP ####
## Start comment block
# echo "WARNING: portions of script `basename "$BASH_SOURCE"` commented out!"
# : <<'COMMENT_BLOCK_secondary_sources'
#### TEMP ####

#### TEMP ####
## End comment block
# COMMENT_BLOCK_secondary_sources
#### TEMP ####

## Exit all scripts
# echo "EXITING script `basename "$BASH_SOURCE"`"; exit 0

######################################################
# Set parameters, load functions & confirm operation
# 
# Loads only local parameters if called by master script.
# Otherwise loads all parameters, functions and options
# Local parameters $db_private and $dev_schema_adb_private used ONLY if
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

if [[ "$e" = "true" && -z ${master+x} ]]; then 

	# Reset confirmation message
	msg_conf="$(cat <<-EOF

	Run process '$pname' with following options:
	
	Database:		$db_private
	Schema:			$dev_schema_adb_private
	Sources:		$src_list
		
EOF
	)"		
	confirm "$msg_conf"
fi

if [ -z ${db_private+x} ] || [ -z ${dev_schema_adb_private+x} ]; then
	echo "ERROR: Missing database and/or schema!"; exit 1;
fi
	
#########################################################################
# Main
#########################################################################

echoi $e "Executing module '$local_basename'"

############################################
# Delete the source records
############################################

echoi $e "- Removing secondary records for primary sources:"

echoi $e -n "-- Adding indexes..."
# Remove indexes if any
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema_adb_private -f $DIR_LOCAL/sql/drop_indexes.sql
# Index datasource
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema_adb_private -f $DIR_LOCAL/sql/index_datasource.sql
# Index dataset
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema_adb_private -f $DIR_LOCAL/sql/index_dataset.sql
source "$DIR/includes/check_status.sh"	

echoi $e "-- Removing secondary records for source:"
for primary_src in $primary_sources; do
	echoi $e -n "--- $primary_src..."
	PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema_adb_private -v primary_src="$primary_src" -f $DIR_LOCAL/sql/remove_secondary_source.sql
	source "$DIR/includes/check_status.sh"	
done

echoi $e -n "-- Dropping indexes..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema_adb_private -f $DIR_LOCAL/sql/drop_indexes.sql
source "$DIR/includes/check_status.sh"	

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [[ "$e" = "true" && -z ${master+x} ]]; then 
source "$DIR/includes/finish.sh"; fi
