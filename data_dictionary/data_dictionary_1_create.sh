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

# Comment-block tags - Use for all temporary comment blocks

#### TEMP ####
# echo "WARNING: portions of script `basename "$BASH_SOURCE"` commented out!"
## Start comment block
# : <<'COMMENT_BLOCK_xxx'

## End comment block
# COMMENT_BLOCK_xxx
#### TEMP ####

## Exit all scripts
# echo "EXITING script `basename "$BASH_SOURCE"`"; exit 0

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

############################################
# Create the tables, updating with previous
# values if requested
############################################

# Import previous definitions if requested
# Must be done before next step, in case recycling content from same schema,
# as next step will wipe out the previous tables
if [ "$dd_import_previous" == "true" ]; then
	echoi $e -n "- Saving table and column descriptions from previous version in schema=\"$dd_src_sch\"..."
	PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v src_sch=$dd_src_sch -v sch=$dev_schema -f $DIR_LOCAL/sql/import_previous.sql
	source "$DIR/includes/check_status.sh"		
fi

# Create data dictionary tables
echoi $e -n "- Creating data dictionary..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/create_data_dictionary.sql
source "$DIR/includes/check_status.sh"	

if [ "$dd_import_previous" == "true" ]; then
	# Update table and column definitions with previous definitions
	echoi $e -n "- Inserting table and column descriptions from previous version..."
	PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/update_from_previous_tbls_cols.sql
	source "$DIR/includes/check_status.sh"		

	# Loop through table+columns of all constrained-value columns,
	# inserting table, column and values into values table
	# Table dd_vals_columns_prev is the result of an inner join of
	# all columns in the current database (in table 
	# data_dictionary_columns) on all fixed-value columns in the 
	# previous database (in table dd_vals_prev). The join removes
	# any columns no longer present in current database.  
	echoi $e "- Inserting constrained column values:"
	OIFS=$IFS	# Save internal field separator so can restore 
	PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -qt -c "select table_name, column_name from ${dev_schema}.dd_vals_columns_prev order by table_name, column_name" | while read -a record; do
		IFS='|' read -a cols <<< "${record[*]}"
	
		# Assign column values to variables, trimming external whitespace
		tbl="$(echo -e ${cols[0]} | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
		col="$(echo -e ${cols[1]} | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"	

		echoi $e -r "-- "$tbl"."$col"        "

		# Form SQL & execute, if table exists
		sql="INSERT INTO ${dev_schema}.data_dictionary_values (table_name, column_name, value
		) SELECT DISTINCT '"$tbl"', '"$col"', "$col" FROM ${dev_schema}."$tbl" ORDER BY "$col
		#echo $sql
		PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -c "${sql}"
	done 
	echoi $e ""
	source "$DIR/includes/check_status.sh"	
	IFS=$OIFS
	
	# Update with previous constrained value definitions, if any
	echoi $e -n "- Inserting table and column descriptions from previous version..."
	PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/update_from_previous_vals.sql
	source "$DIR/includes/check_status.sh"		
	
	# Update with previous constrained value definitions, if any
	echoi $e -n "- Dropping temp tables..."
	PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/drop_temp_tables.sql
	source "$DIR/includes/check_status.sh"		
fi

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
