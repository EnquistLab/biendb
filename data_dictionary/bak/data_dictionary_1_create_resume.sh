#!/bin/bash

#########################################################################
# Purpose: Creates data dictionary views and tables and extracts CSV files 
# 	of table and column definitions for manual editing. 
#  
# Notes:
# 1. Import table and column descriptions from previous db version if 
#	this option set in main params file.
# 2. Files are extracted to data directory for this module. After editing, 
# 	revised files are uploaded by separate script and used to update the
# 	data dictionary views & tables.
#
# Authors: Brad Boyle (bboyle@email.arizona.edu)
#########################################################################

: <<'COMMENT_BLOCK_x'
COMMENT_BLOCK_x

######################################################
# Set parameters, load functions & confirm operation
# 
# Loads only local parameters if called by master script.
# Otherwise loads all parameters, functions and options
# Local parameters $db and $dev_schema used ONLY if
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

######################################################
# Custom confirmation message. 
# Will only be displayed if running standalone 
# and -s (silent) option not used.
######################################################

if [[ "$i" = "true" && -z ${master+x} ]]; then 

	if [[ "$dd_import_previous" == "true" ]]; then
		dd_src_sch_disp=$dd_src_sch
	else
		dd_src_sch_disp="n/a"
	fi

	# Reset confirmation message
	msg_conf="$(cat <<-EOF

	Run process '$pname' with following options:
	
	Reuse previous version?		$dd_import_previous
	Previous version source schema:	$dd_src_sch_disp
	Data directory:	$data_dir_local
		
EOF
	)"		
	confirm "$msg_conf"
fi
	
#########################################################################
# Main
#########################################################################

echoi $e "Executing module '$local_basename'"


	
	# Update with previous constrained value definitions, if any
	echoi $e -n "- Inserting table and column descriptions from previous version..."
	PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/update_from_previous_vals.sql
	source "$DIR/includes/check_status.sh"		
	
	# Update with previous constrained value definitions, if any
	echoi $e -n "- Dropping temp tables..."
	PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/drop_temp_tables.sql
	source "$DIR/includes/check_status.sh"		
	

############################################
# Export all dd tables for manual editing &
# re-import in step 2
############################################

echoi $e "- Exporting CSV files to '$data_dir_local':"

echoi $e -n "-- Tables: '$dd_file_tables'..."
sql="\copy (select * from data_dictionary_tables) to ${data_dir_local}/${dd_file_tables} csv header"
PGOPTIONS='--client-min-messages=warning' psql  -U $user -d $db_private -q << EOF
\set ON_ERROR_STOP on
SET search_path TO $dev_schema;
$sql
EOF
source "$DIR/includes/check_status.sh"

echoi $e -n "-- Columns: '$dd_file_cols'..."
sql="\copy (select * from data_dictionary_columns) to ${data_dir_local}/${dd_file_cols} csv header"
PGOPTIONS='--client-min-messages=warning' psql  -U $user -d $db_private -q << EOF
\set ON_ERROR_STOP on
SET search_path TO $dev_schema;
$sql
EOF
source "$DIR/includes/check_status.sh"

echoi $e -n "-- Column values: '$dd_file_vals'..."
sql="\copy (select * from data_dictionary_values) to ${data_dir_local}/${dd_file_vals} csv header"
PGOPTIONS='--client-min-messages=warning' psql  -U $user -d $db_private -q << EOF
\set ON_ERROR_STOP on
SET search_path TO $dev_schema;
$sql
EOF
source "$DIR/includes/check_status.sh"

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi
