#!/bin/bash

#########################################################################
# Purpose: Import revised CSV files of table and column definitions and 
#	update materialized views and tables
#  
# Authors: Brad Boyle (bboyle@email.arizona.edu)
#########################################################################

: <<'COMMENT_BLOCK_x'
COMMENT_BLOCK_x
#echo; echo "EXITING script `basename "$BASH_SOURCE"`"; exit 0

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
	
#########################################################################
# Main
#########################################################################

echoi $e "Executing module '$local_basename'"

################################################
# Update data dictionary tables
################################################

# create revised results tables
echoi $e -n "- Creating revised results tables..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/create_data_dictionary_revised.sql
source "$DIR/includes/check_status.sh"	

# Tables
# Check if revised file exists before proceeding
echoi $e "- Updating table definitions:"
file=$data_dir_local"/"$dd_file_tables_revised
if [ ! -f "$file" ]; then
    echoi $e "WARNING: File $file not found! Can't revise table definitions."
else
	echoi $e -n "-- Importing revision file..."
	sql="\copy dd_tables_revised FROM ${data_dir_local}/${dd_file_tables_revised} csv header"
	PGOPTIONS='--client-min-messages=warning' psql $db_private $user -q << EOF
	\set ON_ERROR_STOP on
	SET search_path TO $dev_schema;
	$sql
EOF
	source "$DIR/includes/check_status.sh"	
	
	echoi $e -n "-- Applying revisions..."
	PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/data_dictionary_update_tables.sql
	source "$DIR/includes/check_status.sh"	
fi

# Columns
echoi $e "- Updating column definitions:"
file=$data_dir_local"/"$dd_file_cols_revised
if [ ! -f "$file" ]; then
    echoi $e "WARNING: File $file not found! Can't revise column definitions."
else
	echoi $e -n "-- Importing revision file..."
	sql="\copy dd_cols_revised FROM ${data_dir_local}/${dd_file_cols_revised} csv header"
	PGOPTIONS='--client-min-messages=warning' psql $db_private $user -q << EOF
	\set ON_ERROR_STOP on
	SET search_path TO $dev_schema;
	$sql
EOF
	source "$DIR/includes/check_status.sh"	
	
	echoi $e -n "-- Applying revisions..."
	PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/data_dictionary_update_columns.sql
	source "$DIR/includes/check_status.sh"	
fi

# Values
echoi $e "- Updating constrained value definitions:"
file=$data_dir_local"/"$dd_file_vals_revised
if [ ! -f "$file" ]; then
    echoi $e "WARNING: File $file not found! Can't revise value definitions."
else
	echoi $e -n "-- Importing revision file..."
	sql="\copy dd_vals_revised FROM ${data_dir_local}/${dd_file_vals_revised} csv header"
	PGOPTIONS='--client-min-messages=warning' psql $db_private $user -q << EOF
	\set ON_ERROR_STOP on
	SET search_path TO $dev_schema;
	$sql
EOF
	source "$DIR/includes/check_status.sh"	

	echoi $e -n "-- Applying revisions..."
	PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/data_dictionary_update_values.sql
	source "$DIR/includes/check_status.sh"	
fi

################################################
# Add the comments to the schema
################################################

echoi $e "- Adding comments to schema:"

echoi $e -n "-- Tables..."
OIFS=$IFS	# Save internal field separator so can restore 
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -lqt -c "select table_name, description from ${dev_schema}.data_dictionary_tables" | while read -a record ; do
	IFS='|' read -a cols <<< "${record[*]}"
	
	# Assign column values to variables, trimming external whitespace
	tbl="$(echo -e ${cols[0]} | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
	desc="$(echo -e ${cols[1]} | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"	

	#Escape any single quotes in description
	desc2=${desc//\'/\'\'}; desc=$desc2

	# Form SQL & execute, if table exists
	exists_tbl=$(exists_table_psql -u $user -d $db_private -s $dev_schema -t $tbl)
	if [ $exists_tbl == "t" ]; then
		if [ "$desc" == "" ]; then
			sql="COMMENT ON TABLE \""$dev_schema"\".\""$tbl"\" IS NULL"
		else
			sql="COMMENT ON TABLE \""$dev_schema"\".\""$tbl"\" IS '"$desc"'"
		fi
		PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -c "${sql}"
		#echo $sql
	fi
done 
source "$DIR/includes/check_status.sh"	
IFS=$OIFS

#i=100
#while read -a record && ((i--)) ; do
echoi $e -n "-- Columns..."
OIFS=$IFS	# Save internal field separator so can restore 
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -lqt -c "select table_name, column_name, description from ${dev_schema}.data_dictionary_columns" | while read -a record; do
	IFS='|' read -a cols <<< "${record[*]}"
	
	# Assign column values to variables, trimming external whitespace
	tbl="$(echo -e ${cols[0]} | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
	col="$(echo -e ${cols[1]} | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
	desc="$(echo -e ${cols[2]} | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"	

	#Escape any single quotes in description
	desc2=${desc//\'/\'\'}; desc=$desc2

	# Form SQL & execute, if table exists
	exists_col=$(exists_column_psql -u $user -d $db_private -s $dev_schema -t $tbl -c $col)
	if [ $exists_col == "t" ]; then
		if [ "$desc" == "" ]; then
			sql="COMMENT ON COLUMN \""$dev_schema"\".\""$tbl"\".\""$col"\" IS NULL"
		else
			sql="COMMENT ON COLUMN \""$dev_schema"\".\""$tbl"\".\""$col"\" IS '"$desc"'"
		fi
		PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -c "${sql}"
		#echo $sql
	fi
done 
source "$DIR/includes/check_status.sh"	
IFS=$OIFS

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi
