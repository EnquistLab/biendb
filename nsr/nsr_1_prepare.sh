#!/bin/bash

#########################################################################
# Purpose: Extract all political division for validation with NSR
#
# Authors: Brad Boyle (bboyle@email.arizona.edu)
#########################################################################

# Comment-block tags - Use for all temporary comment blocks

#### TEMP ####
# echo "WARNING: portions of script `basename "$BASH_SOURCE"` commented out!"
## Other temporary code to be executed before comment block
## Start comment block
# : <<'COMMENT_BLOCK_xxx'

## End comment block
# COMMENT_BLOCK_xxx
## Temporary code to be executed after comment block
#### TEMP ####

## Exit all scripts
# echo "EXITING script `basename "$BASH_SOURCE"`"; exit 0


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

if [ -z ${master+x} ]; then
	echoi $e "Executing module '$local_basename'"
else
	echoi $e "Executing module 'NSR'"
fi

echoi $e -n "- Creating nsr_submitted tables..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/create_nsr_submitted.sql
source "$DIR/includes/check_status.sh"	

echoi $e "- Extracting raw NSR input columns from table:"

echoi $e -n "-- vfoi..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/nsr_extract_vfoi.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "-- agg_traits..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/nsr_extract_agg_traits.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Extracting unique values to table nsr_submitted..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/prepare_nsr_submitted.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Exporting CSV file to application data directory..."
sql="\copy (select taxon, country, state_province, county_parish, user_id from nsr_submitted) to ${validation_app_data_dir}/${submitted_filename} csv header"
PGOPTIONS='--client-min-messages=warning' psql  -U $user -d $db_private -q << EOF
\set ON_ERROR_STOP on
SET search_path TO $dev_schema;
$sql
EOF
source "$DIR/includes/check_status.sh"

# Echo file and destination directory
echoi $e "-- File: "$submitted_filename
echoi $e "-- Destination directory: "$validation_app_data_dir

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi

######################################################
# End script
######################################################