#!/bin/bash

#########################################################################
# Purpose: Import & post_process GNRS results
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
#DIR_LOCAL="${BASH_SOURCE%/*}"
DIR_LOCAL="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
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

#########################################################################
# Import GNRS results 
#########################################################################

echoi $e -n "- Creating GNRS results table..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/create_gnrs.sql
source "$DIR/includes/check_status.sh"	

echoi $i -n "- Importing GNRS validation results..."
sql="\COPY gnrs FROM '${validation_app_data_dir}/${results_filename}' DELIMITER ${results_file_delim} CSV ${results_file_header};"
PGOPTIONS='--client-min-messages=warning' psql $db_private $user -q << EOF
\set ON_ERROR_STOP on
SET search_path TO $dev_schema;
$sql
EOF
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Removing duplicate values from GNRS results table..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/gnrs_make_unique.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Indexing GNRS results table..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/index_gnrs.sql
source "$DIR/includes/check_status.sh"	

# Check that candidate pkey field poldiv_full is still unique
# Throw error and abort if not
check_pk -u $user -d $db -s $dev_schema -t gnrs -c poldiv_full

#########################################################################
# Update GNRS results columns in original tables
#########################################################################

echoi $e "- Updating GNRS results columns in table:"

echoi $e -n "-- view_full_occurrence_individual_dev..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/gnrs_update_vfoi.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "-- agg_traits..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/gnrs_update_traits.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "-- ih..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/gnrs_update_ih.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "-- plot_metadata..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/gnrs_update_plot_metadata.sql
source "$DIR/includes/check_status.sh"	

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi

######################################################
# End script
######################################################