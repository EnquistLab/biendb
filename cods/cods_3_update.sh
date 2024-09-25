#!/bin/bash

#########################################################################
# Purpose: Import & post_process CODS results
#
# Authors: Brad Boyle (bboyle@email.arizona.edu)
#########################################################################

# Comment-block tags - Use for all temporary comment blocks
# Replace xxx with unique integer or string for each pair of comment-start
# comment-stop code blocks

#### TEMP ####
# echo "WARNING: portions of script `basename "$BASH_SOURCE"` commented out!"
## Temporary code, if any, to be executed before comment block
## Start comment block
# : <<'COMMENT_BLOCK_xxx'

## End comment block
# COMMENT_BLOCK_xxx
## Temporary code, if any, to be executed after comment block
#### TEMP ####

## Single line command to exit all scripts & echo name of current script
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

# Start error log
echo "Error log
" > /tmp/log.txt

#########################################################################
# Main
#########################################################################

echoi $e "Importing CODS results:"

echoi $e -n "- Creating tables..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/create_cods_results_tables.sql
source "$DIR/includes/check_status.sh"

echoi $i -n "- Importing CODS proximity validation results..."
sql="\COPY cods_proximity FROM '${validation_app_data_dir}/${results_filename_prox}' DELIMITER ',' CSV HEADER;"
PGOPTIONS='--client-min-messages=warning' psql $db_private $user -q << EOF
\set ON_ERROR_STOP on
SET search_path TO $dev_schema;
$sql
EOF
source "$DIR/includes/check_status.sh"	
	
echoi $i -n "- Importing CODS keyword validation results..."
sql="\COPY cods_keyword FROM '${validation_app_data_dir}/${results_filename_desc}' DELIMITER ',' CSV HEADER;"
PGOPTIONS='--client-min-messages=warning' psql $db_private $user -q << EOF
\set ON_ERROR_STOP on
SET search_path TO $dev_schema;
$sql
EOF
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Indexing tables..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/index_tables.sql
source "$DIR/includes/check_status.sh"	

#########################################################################
# Check candidate pkey fields unique in validation results tables
#########################################################################
echoi $e "Checking candidate pkeys in CODS results tables:"

# Proximity validation results table
echoi $e -n "- cods_proximity..."
check_pk -q -u $user -d $db_private -s $dev_schema -t cods_proximity -c user_id
source "$DIR/includes/check_status.sh"	

# Keyword validation results
# Do separately for each target table
# WHERE clause required so must do this one from scratch
echoi $e -n "- cods_keyword..."

# view_full_occurrence_individual
sql_is_unique="SELECT NOT EXISTS ( SELECT tbl_id, COUNT(*) FROM ${dev_schema}.cods_keyword WHERE tbl_name='view_full_occurrence_individual' GROUP BY tbl_id HAVING COUNT(*)>1 ) AS a"
is_unique=`psql -h $host -U $user -d $db_private -qt -c "$sql_is_unique" | tr -d '[[:space:]]'`
if [[ "$is_unique" == "f" ]]; then
	echo "ERROR: Column tbl_id NOT UNIQUE for tbl_name='view_full_occurrence_individual'!"; exit 1
fi

# agg_traits
sql_is_unique="SELECT NOT EXISTS ( SELECT tbl_id, COUNT(*) FROM ${dev_schema}.cods_keyword WHERE tbl_name='agg_traits' GROUP BY tbl_id HAVING COUNT(*)>1 ) AS a"
is_unique=`psql -h $host -U $user -d $db_private -qt -c "$sql_is_unique" | tr -d '[[:space:]]'`
if [[ "$is_unique" == "f" ]]; then
	echo "ERROR: Column tbl_id NOT UNIQUE for tbl_name='agg_traits'!"; exit 1
fi

source "$DIR/includes/check_status.sh"	

#########################################################################
# Update CODS results columns in original tables
#########################################################################

echoi $e "Updating CODS results columns in table:"

echoi $e "- view_full_occurrence_individual_dev:"

echoi $e -n "-- Proximity results..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/cods_update_vfoi_prox.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "-- Keyword results..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/cods_update_vfoi_key.sql
source "$DIR/includes/check_status.sh"	

echoi $e "- agg_traits..."

echoi $e -n "-- Proximity results..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/cods_update_agg_traits_prox.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "-- Keyword results..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/cods_update_agg_traits_key.sql
source "$DIR/includes/check_status.sh"	

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi

######################################################
# End script
######################################################