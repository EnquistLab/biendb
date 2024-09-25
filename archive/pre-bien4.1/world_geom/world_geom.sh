#!/bin/bash

#########################################################################
# Purpose:	Copies table world_geom from public database to private 
#	analytical schema. 
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

: <<'COMMENT_BLOCK_x'
COMMENT_BLOCK_x

############################################################
# Copy table from production schema to development schema
############################################################

echoi $i -n "- Copying table 'world_geom' from '$prod_schema_adb_private' to '$dev_schema_adb_private' in db '$db_private'..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v prod_schema=$prod_schema_adb_private -v dev_schema=$dev_schema_adb_private -f $DIR_LOCAL/sql/copy_world_geom.sql 
source "$DIR/includes/check_status.sh"

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi


