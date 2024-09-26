#!/bin/bash

#########################################################################
# Purpose: Copies legacy analytical tables from core schema to   
# 	development analytical schema, adding new blank columns and removing  
# 	unused columns
#
# Requirements:
#	1. Schema analytical_db_dev must already exist and be owned by bien  
#
# Note: Columns added are place-holders only. Due to size of this table,  
#	columns are re-created and populated in separate "CREATE TABLE AS"  
#	operations. UPDATE statements are too slow and are not used.  
#	Creating all columns at once, with new columns added as "dummy" 
#	columns allows reordering of columns and re-used of the same
#	"SELECT col1, col2, col3, ... colx" code in each of several "CREATE  
#	TABLE AS" operation.
#
# Authors: Brad Boyle (bboyle@email.arizona.edu)
# Date created: 21 March 2017
# Date first release: 21 March 2017
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

# Load startup script for local files
# Sets remaining parameters and options, and issues confirmation
# and startup messages
source "$DIR/includes/startup_local.sh"	

# Construct LIMIT clause if applicable (for testing only)
if [ $use_limit = "true" ]; then
	sql_limit=$sql_limit_global
else
	sql_limit=""
fi
	
#########################################################################
# Main
#########################################################################

echoi $e "Executing module 'Copy legacy tables':"

# Copy view_full_occurrence
echoi $e -n "- 'view_full_occurrence_individual'..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v target_schema=$dev_schema_adb_private -v src_schema=$prod_schema_adb_private -v limit="$sql_limit" -v where="$sql_where_vfoi" -f $DIR_LOCAL/sql/copy_table_vfoi_exact.sql
source "$DIR/includes/check_status.sh"	# check and report status of query

# Copy analytical_stem
echoi $e -n "- 'analytical_stem'..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v target_schema=$dev_schema_adb_private -v src_schema=$prod_schema_adb_private -v limit="$sql_limit"  -v where="$sql_where_astem" -f $DIR_LOCAL/sql/copy_table_analytical_stem_exact.sql
source "$DIR/includes/check_status.sh"	# check and report status of query

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi
