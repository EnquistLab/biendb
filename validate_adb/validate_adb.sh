#!/bin/bash

#########################################################################
# Purpose: Validates completed development analytical database
#
# Notes:
#	1. Parameters specifying database, schema, etc. are loaded from 
#		parameter file params.sh. Sets of parameters relevant to a 
#		particular database should be backed up by saving a copy of 
#		the params file with an appropriate suffix (e.g., 
#		"params.sh.adb_private_dev". Copy and replace the existing
#		params.sh file with the appropriate params backup file.
#  
# Author: Brad Boyle (bboyle@email.arizona.edu)
#########################################################################

: <<'COMMENT_BLOCK_x'
COMMENT_BLOCK_x
#echoi $e; echoi $e "EXITING script `basename "$BASH_SOURCE"`"; exit 0

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
# Custom confirmation message. 
# Will only be displayed if running as
# standalone script and -s (silent) option not used.
######################################################

if [[ "$i" = "true" && -z ${master+x} ]]; then 

	# Reset confirmation message
	msg_conf="$(cat <<-EOF

	Process '$pname' will use following parameters: 
	
	Database:	$db
	Schema:		$sch
	
EOF
	)"		
	confirm "$msg_conf"
fi

#########################################################################
# Main
#########################################################################

echoi $e "Executing module '$local_basename'"

######################################################
# Set error tracking parameters
######################################################

errs=0

######################################################
# Check required tables and columns
######################################################

echoi $e "Checking existence of required tables:"
for tbl in $required_tables; do
	echoi $e -n "- $tbl..."
	exists_tbl=$(exists_table_psql -u $user -d $db -s $sch -t $tbl )
	if [[ "$exists_tbl" == "f" ]]; then
		echoi $e "FAIL!"
		let "errs++"
	else
		echoi $e "pass"
	fi
done

echoi $e "Checking existence of required columns:"
for tblcol in $required_columns; do
	tblcol2=${tblcol//,/ }	# Replace all ',' with ' ', the default IFS
	tblcol_arr=($tblcol2)	# Split into array using IFS
	tbl=${tblcol_arr[0]}
	col=${tblcol_arr[1]}
	tblcol_disp=${tblcol/,/.}	# Convert to std tbl.col format

	echoi $e -n "- $tblcol_disp..."
	exists_column=$(exists_column_psql -u $user -d $db -s $sch -t $tbl -c $col )
	if [[ "$exists_column" == "f" ]]; then
		echoi $e "FAIL!"
		let "errs++"
	else
		echoi $e "pass"
	fi
done

######################################################
# Check validation fkeys populated
######################################################

echoi $e "Checking validation fkeys not all null:"

for check_tbl in $validation_fkeys_check_tables; do
	echoi $e "- $check_tbl:"

	for fk_col in $validation_fk_cols; do
		echoi $e -n "-- fkey: $fk_col..."
		test=`psql -U $user -d $db -qt -v sch=$sch -v check_tbl=$check_tbl -v fk_col=$fk_col -f "sql/check_fk_not_null.sql" | tr -d '[[:space:]]'`
		if [[ "$test" == "f" ]]; then
			echoi $e "FAIL!"
			let "errs++"
		else
			echoi $e "pass"
		fi
	done
	
done

######################################################
# Check embargoes correctly applied
# Public database only
######################################################

if [[ "$db" == "$db_public" ]]; then 
	echoi $e "Embargo checks:"
	
	for check in $embargo_checks; do
		echoi $e -n "- $check..."
		test=`psql -U $user -d $db -qt -v sch=$sch -f "sql/${check}.sql" | tr -d '[[:space:]]'`
		if [[ "$test" == "t" ]]; then
			echoi $e "FAIL!"
			let "errs++"
		else
			echoi $e "pass"
		fi
	done
fi

######################################################
# Taxonomic checks
######################################################

if [[ "$db" == "$db_private" ]]; then 
	echoi $e "Taxonomic checks:"

	# Tests are in SQL files with base names in parameter $taxonomic_checks
	for check in $taxonomic_checks; do
		echoi $e -n "- $check..."
		test=`psql -U $user -d $db -lqt -v sch=$sch -f "sql/${check}.sql" | tr -d '[[:space:]]'`
		if [[ "$test" == "t" ]]; then
			echoi $e "FAIL!"
			let "errs++"
		else
			echoi $e "pass"
		fi
	done
fi

######################################################
# Geovalid checks
######################################################

if [[ "$db" == "$db_private" ]]; then 
	echoi $e "Geovalid checks:"

	# Tests are in SQL files with base names in parameter $geovalid_checks
	for check in $geovalid_checks; do
		echoi $e -n "- $check..."
		test=`psql -U $user -d $db -lqt -v sch=$sch -f "sql/${check}.sql" | tr -d '[[:space:]]'`
		if [[ "$test" == "t" ]]; then
			echoi $e "FAIL!"
			let "errs++"
		else
			echoi $e "pass"
		fi
	done
fi

######################################################
# Check for negative or zero plot area
######################################################

echoi $e "Negative plot area checks:"

# Tests are in SQL files with base names in parameter $geovalid_checks
for tbl in $plot_area_check_tables; do
	echoi $e -n "- Table \"$tbl\"..."
	test=`psql -U $user -d $db -lqt -v sch=$sch -v tbl=$tbl -f "sql/plot_areas_positive.sql" | tr -d '[[:space:]]'`
	if [[ "$test" == "t" ]]; then
		echoi $e "FAIL!"
		let "errs++"
	else
		echoi $e "pass"
	fi
done

######################################################
# Report errors
######################################################

echoi $e; echoi $e "------------------------------------------------"
if [ "$errs" -gt 0 ]; then 
	echoi $e "Total errors found: $errs"
else
	echoi $e "No errors found"
fi

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi