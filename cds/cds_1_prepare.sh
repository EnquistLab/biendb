#!/bin/bash

#########################################################################
# Purpose: Extract all geocoordinates for validation with CDS
#
# Authors: Brad Boyle (bboyle@email.arizona.edu)
#########################################################################

# Comment-out code, if needed
# Runtime echo prevents temporary comment blocks from being "forgotten"

#### TEMP ####
# Start comment block
# echo "WARNING: portions of script `basename "$BASH_SOURCE"` commented out!"
# : <<'COMMENT_BLOCK_xxx'
#### TEMP ####

#### TEMP ####
# End comment block
# COMMENT_BLOCK_xxx
#### TEMP ####

# Exit all scripts
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

#########################################################################
# Main
#########################################################################

echoi $e "Executing module '$local_basename'"

#########################################################################
# Extract and export political divisions
#########################################################################

# Drop indexes on large tables for performance
# Note location of the following two scripts
echoi $e "- Dropping existing indexes on table:"

echoi $e -n "-- view_full_occurrence_individual..."
drop_indexes -q -p -u $user -d $db_private -s $dev_schema -t "view_full_occurrence_individual_dev"
echoi $e "done"

echoi $e -n "-- agg_traits..."
drop_indexes -q -p -u $user -d $db_private -s $dev_schema -t "agg_traits"
echoi $e "done"

echoi $e -n "- Extracting all verbatim geocoordinate to table cds_submitted..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/prepare_cds_submitted.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Exporting CSV file of political divisions for scrubbing by CDS..."
# Note:
#	1. Header not included
#	2. No user_id
sql="\copy (select latitude_verbatim, longitude_verbatim from cds_submitted) to ${validation_app_data_dir}/${submitted_filename} csv header"
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