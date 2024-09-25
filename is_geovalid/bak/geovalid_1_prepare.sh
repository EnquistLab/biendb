#!/bin/bash

#########################################################################
# Purpose: Extracts CSV file of primary keys (taxonobservation_id), 
# geocoordinates and political divisions from table vfoi for 
# point-in-polygon geovalidation 
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

# Start error log
echo "Error log
" > $DIR_LOCAL/log.txt

#########################################################################
# Main
#########################################################################

echoi $e "Executing module '$local_basename'"

echoi $e "- Exporting CSV files of coordinates for geovalidation:"

# Added DISTINCT to prevent duplicates from multiplying further
# Table ids should be unique now, but have had anomalies in the past
# Distinct will ensure that problem does not original in this validation
# Slow, but will speed up validation and update
# Note user of 'is distinct from' to include nulls
echoi $e -n "-- view_full_occurrence_individual..."
sql="\copy (select distinct 'vfoi' as tbl, taxonobservation_id as id, country, state_province, county, latitude, longitude from view_full_occurrence_individual_dev where latitude is not null and longitude is not null and country is not null and is_geovalid is distinct from 0) to ${data_dir_local}/tempfile1 csv header"
PGOPTIONS='--client-min-messages=warning' psql  -U $user -d $db_private -q << EOF
\set ON_ERROR_STOP on
SET search_path TO $dev_schema;
$sql
EOF
source "$DIR/includes/check_status.sh"

# Note user of 'is distinct from' to include nulls
echoi $e -n "-- agg_traits..."
sql="\copy (select distinct 'traits' as tbl, id as id, country, state_province, county, latitude, longitude from agg_traits where latitude is not null and longitude is not null and country is not null and is_geovalid is distinct from 0) to ${data_dir_local}/tempfile2 csv"
PGOPTIONS='--client-min-messages=warning' psql  -U $user -d $db_private -q << EOF
\set ON_ERROR_STOP on
SET search_path TO $dev_schema;
$sql
EOF
source "$DIR/includes/check_status.sh"

echoi $e -n "- Concatenating all to file 'data_dir_local/$submitted_filename'..."
cat $data_dir_local/tempfile1 $data_dir_local/tempfile2 > $data_dir_local/$submitted_filename
rm $data_dir_local/tempfile*
source "$DIR/includes/check_status.sh"

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi

######################################################
# End script
######################################################