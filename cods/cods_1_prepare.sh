#!/bin/bash

#########################################################################
# Purpose: Extract observations for scrubbing with CODS validation
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
" > /tmp/log.txt

#########################################################################
# Main
#########################################################################

echoi $e "Executing module '$local_basename'"

echoi $e -n "- Creating cods_submitted tables..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/create_cods_submitted_tables.sql
source "$DIR/includes/check_status.sh"	

echoi $e "- Clearing indexes from tables:"
echoi $e -n "-- view_full_occurrence_individual..."
drop_indexes -q -p -u $user -d $db_private -s $dev_schema -t "view_full_occurrence_individual_dev"
echoi $e "done"

echoi $e -n "-- agg_traits..."
drop_indexes -q -p -u $user -d $db_private -s $dev_schema -t "agg_traits"
echoi $e "done"

echoi $e -n "- Preparing tables..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/prepare_tables.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Extracting proximity data from tables..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/extract_cods_prox_submitted.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Extracting description data from tables..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/extract_cods_desc_submitted.sql
source "$DIR/includes/check_status.sh"	

echoi $e "- Exporting CSV files to application data directory:"

echoi $e -n "-- cods_prox_submitted..."
sql="\copy (SELECT latlong_text, latitude, longitude FROM cods_prox_submitted) to ${validation_app_data_dir}/${submitted_filename_prox} csv header"
PGOPTIONS='--client-min-messages=warning' psql  -U $user -d $db_private -q << EOF
\set ON_ERROR_STOP on
SET search_path TO $dev_schema;
$sql
EOF
source "$DIR/includes/check_status.sh"

echoi $e -n "-- cods_desc_submitted..."
sql="\copy cods_desc_submitted to ${validation_app_data_dir}/${submitted_filename_desc} csv header"
PGOPTIONS='--client-min-messages=warning' psql  -U $user -d $db_private -q << EOF
\set ON_ERROR_STOP on
SET search_path TO $dev_schema;
$sql
EOF
source "$DIR/includes/check_status.sh"

# Echo file and destination directory
echoi $e "-- Files:"
echoi $e "--- ${submitted_filename_prox}"
echoi $e "--- ${submitted_filename_desc}"
echoi $e "-- Destination directory: ${validation_app_data_dir}"

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi

######################################################
# End script
######################################################