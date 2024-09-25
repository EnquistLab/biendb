#!/bin/bash

########## UNDER CONSTRUCTION! #################

#########################################################################
# Purpose: Import & post_process TNRS results
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

modname=`basename "$BASH_SOURCE"`
echoi $e "Executing module '$modname'"

#########################################################################
# Import TNRS results 
#########################################################################

echoi $e -n "- Creating TNRS results tables..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/create_tnrs_results_tables.sql
source "$DIR/includes/check_status.sh"	

# Import parsing results
echoi $i -n "- Importing TNRS parsing results..."
sql="\COPY tnrs_parsed FROM '${data_dir_local}/${tnrs_parsed_filename}' DELIMITER E'\t' CSV HEADER quote E'\b'"
PGOPTIONS='--client-min-messages=warning' psql $db_private $user -q << EOF
\set ON_ERROR_STOP on
SET search_path TO $dev_schema;
$sql
EOF
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Setting empty strings to null..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -c "SELECT public.f_empty2null('${dev_schema}.tnrs_parsed')" > /dev/null >> $tmplog
source "$DIR/includes/check_status.sh"

echoi $i -n "- Importing TNRS resolution results..."
sql="\COPY tnrs_scrubbed FROM '${data_dir_local}/${tnrs_scrubbed_filename}' DELIMITER E'\t' CSV HEADER;"
PGOPTIONS='--client-min-messages=warning' psql $db_private $user -q << EOF
\set ON_ERROR_STOP on
SET search_path TO $dev_schema;
$sql
EOF
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Setting empty strings to null..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -c "SELECT public.f_empty2null('${dev_schema}.tnrs_parsed')" > /dev/null >> $tmplog
source "$DIR/includes/check_status.sh"

#########################################################################
# Merge TNRS results with endangered species table
#########################################################################

echoi $e -n "- Preparing table tnrs_parsed..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/prepare_tnrs_parsed.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Preparing table tnrs_scrubbed..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/prepare_tnrs_scrubbed.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Selecting best match..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/best_match.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Preparing table tnrs..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/prepare_tnrs.sql
source "$DIR/includes/check_status.sh"	

# Applying TNRS results to endangered species table
echoi $e "- Applying TNRS results to table:"

echoi $e -n "-- vfoi..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/apply_tnrs_results_vfoi.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "-- agg_traits..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/apply_tnrs_results_agg_traits.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "-- endangered_taxa_by_source..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/apply_tnrs_results_endangered.sql
source "$DIR/includes/check_status.sh"	

#currscript=`basename "$0"`
#echo "EXITING script $currscript"; exit 0

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi

######################################################
# End script
######################################################