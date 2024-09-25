#!/bin/bash

#########################################################################
# Purpose: Import new data, injecting directly into analytical database
#
# Main script imports all new sources. To import a source separately, 
# 	see script for that source (import_[source_name].sh, also in this
# 	directory.
#
# Authors: Brad Boyle (bboyle@email.arizona.edu)
#########################################################################

: <<'COMMENT_BLOCK_x'
COMMENT_BLOCK_x

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

pname_local="Fix GBIF"

# Load startup script for local files
# Sets remaining parameters and options, and issues confirmation
# and startup messages
source "$DIR/includes/startup_local.sh"	

#########################################################################
# Main
#########################################################################

echoi $e "Executing module '$pname_local'"

echoi $e -n "- Importing GBIF extracts..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema_adb_private -f $DIR_LOCAL/sql/fix_gbif_import.sql
source "$DIR/includes/check_status.sh"

echoi $i -n "- Indexing view_full_occurrence_individual_dev..."
sql="
DROP INDEX IF EXISTS vfoi_datasource_idx;
CREATE INDEX vfoi_datasource_idx ON view_full_occurrence_individual_dev (datasource);
DROP INDEX IF EXISTS vfoi_occurrence_id_idx;
CREATE INDEX vfoi_occurrence_id_idx ON view_full_occurrence_individual_dev (occurrence_id);
"
PGOPTIONS='--client-min-messages=warning' psql $db_private $user -q << EOF
\set ON_ERROR_STOP on
SET search_path TO $dev_schema_adb_private;
$sql
EOF
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Updating gbif observation_type..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema_adb_private -f $DIR_LOCAL/sql/fix_gbif_update.sql
source "$DIR/includes/check_status.sh"

echoi $i -n "- Swapping indexes on view_full_occurrence_individual_dev..."
sql="
DROP INDEX IF EXISTS vfoi_datasource_idx;
DROP INDEX IF EXISTS vfoi_occurrence_id_idx;
DROP INDEX IF EXISTS vfoi_observation_type_idx;
CREATE INDEX vfoi_observation_type_idx ON view_full_occurrence_individual_dev (observation_type);
"
PGOPTIONS='--client-min-messages=warning' psql $db_private $user -q << EOF
\set ON_ERROR_STOP on
SET search_path TO $dev_schema_adb_private;
$sql
EOF
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Standardizing remaining observation types..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema_adb_private -f $DIR_LOCAL/sql/fix_gbif_update_vfoi_obstype.sql
source "$DIR/includes/check_status.sh"

echoi $i -n "- Dropping indexes on view_full_occurrence_individual_dev..."
sql="
DROP INDEX IF EXISTS vfoi_observation_type_idx;
"
PGOPTIONS='--client-min-messages=warning' psql $db_private $user -q << EOF
\set ON_ERROR_STOP on
SET search_path TO $dev_schema_adb_private;
$sql
EOF
source "$DIR/includes/check_status.sh"	

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi


