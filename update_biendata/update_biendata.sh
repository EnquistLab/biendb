#!/bin/bash

#### UNDER CONSTRUCTION!!!! ######

#########################################################################
# Purpose: Update biendata.org geospatial db with latest adb observations tables
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
	
	Database:				$db
	Schema:					$sch
	
EOF
	)"		
	confirm "$msg_conf"
fi

#########################################################################
# Main
#########################################################################

echoi $e "Executing module '$local_basename'"










echoi $e; echoi $e "EXITING script `basename "$BASH_SOURCE"`"; exit 0



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
# Check embargoes correctly applied
# Public database only
######################################################

if [[ "$db" == "$db_public" ]]; then 
	echoi $e "Embargo checks:"
	
	for check in $embargo_checks; do
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
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi