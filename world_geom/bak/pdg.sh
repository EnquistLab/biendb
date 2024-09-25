#!/bin/bash


#########################################################################
#########################################################################
####### UNDER CONSTRUCTION !!!!!!! ###################
#########################################################################
#########################################################################




#########################################################################
# Purpose: Performs complete point-in-polygon geovalidation for all tables
# 	in single script, calling validation scripts in external repo pdg and 
#	separate database pdg.
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
# $local_basename = name of this file minus '.sh' extension
# $local_basename should be same as containing directory, as  
# well as local data subdirectory within main data directory, 
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

: <<'COMMENT_BLOCK_x'
COMMENT_BLOCK_x

#########################################################################
# Main
#########################################################################

echoi $e "Executing module '$local_basename'"

for (src_tbl in $src_tbls); do 

# NOT YET READY!!!
# Still need to split table name and id field
# !!!!!!!!!!!!!!!!

echoi $e "Validating geocoordinates in table \"$tbl\":"

	echoi $e -n "- Creating validation tables..."
	PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/create_validation_tables.sql
	source "$DIR/includes/check_status.sh"	

	echoi $e -n "- Extracting validation input..."
	PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -v src_tbl=$src_tbl -v tbl_id=$id_fld -f $DIR_LOCAL/sql/extract_submitted.sql
	source "$DIR/includes/check_status.sh"	

	echoi $e -n "- Exporting CSV file to application data directory..."
	sql="\copy (select id, country_verbatim, state_province_verbatim, county_verbatim from ${tbl_submitted) to ${validation_app_data_dir}/${submitted_filename} csv header"
	PGOPTIONS='--client-min-messages=warning' psql  -U $user -d $db_private -q << EOF
	\set ON_ERROR_STOP on
	SET search_path TO $dev_schema;
	$sql
EOF
	source "$DIR/includes/check_status.sh"

	# Echo file and destination directory
	echoi $e "-- File: "$submitted_filename
	echoi $e "-- Destination directory: "$validation_app_data_dir

done

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi

######################################################
# End script
######################################################