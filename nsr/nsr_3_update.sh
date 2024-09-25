#!/bin/bash

#########################################################################
# Purpose: Import & post_process NSR results
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

#########################################################################
# Main
#########################################################################

echoi $e "Executing module '$local_basename'"

#########################################################################
# Import NSR results 
#########################################################################

echoi $e -n "- Creating NSR results table..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/create_nsr_results.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Creating temp file..."
tr -d '\010' < "${validation_app_data_dir}/${results_filename}" > "${validation_app_data_dir}/${results_filename}.temp.tsv"
source "$DIR/includes/check_status.sh"	

echoi $i -n "- Importing NSR validation results from temp file..."
# The following crashes if any field contains double quotes
#sql="\COPY nsr FROM '${validation_app_data_dir}/${results_filename}' DELIMITER E'\t' CSV HEADER;"
# The next one is crash proof.
# See: https://stackoverflow.com/a/20402913/2757825
# Plus this: https://stackoverflow.com/a/47087496/2757825 (see preceding step)
sql="\COPY nsr FROM '${validation_app_data_dir}/${results_filename}.temp.tsv' WITH CSV HEADER DELIMITER E'\t' QUOTE E'\b' NULL AS '';"
PGOPTIONS='--client-min-messages=warning' psql $db_private $user -q << EOF
\set ON_ERROR_STOP on
SET search_path TO $dev_schema;
$sql
EOF
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Removing temp file..."
rm "${validation_app_data_dir}/${results_filename}.temp.tsv"
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Updating NSR results table..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/prepare_nsr_results.sql
source "$DIR/includes/check_status.sh"	

#########################################################################
# Check that all candidate PKs are unique 
#
# Duplicate values can blow up main analytical table via LEFT JOIN.
# Anomalies in validation results tables are much easier to fix.
#########################################################################

echoi $e "- Checking candidate pkeys unique for NSR tables:"

echoi $e -n "-- table=nsr, cpkey=taxon_poldiv..."
check_pk -q -u $user -d $db_private -s $dev_schema -t nsr -c taxon_poldiv
source "$DIR/includes/check_status.sh"	

echoi $e -n "-- table=nsr_submitted_raw, cpkey=tbl_id, fktable=vfoi..."
sql_is_unique="SELECT NOT EXISTS ( SELECT tbl_id, COUNT(*) FROM ${dev_schema}.nsr_submitted_raw WHERE tbl_name='view_full_occurrence_individual' GROUP BY tbl_id HAVING COUNT(*)>1 ) AS a"
is_unique=`psql -h $host -U $user -d $db_private -qt -c "$sql_is_unique" | tr -d '[[:space:]]'`
if [[ "$is_unique" == "f" ]]; then
	echo "ERROR: Column tbl_id NOT UNIQUE!"; exit 1
fi
source "$DIR/includes/check_status.sh"	

echoi $e -n "-- table=nsr_submitted_raw, cpkey=tbl_id, fktable=agg_traits..."
sql_is_unique="SELECT NOT EXISTS ( SELECT tbl_id, COUNT(*) FROM ${dev_schema}.nsr_submitted_raw WHERE tbl_name='agg_traits' GROUP BY tbl_id HAVING COUNT(*)>1 ) AS a"
is_unique=`psql -h $host -U $user -d $db_private -qt -c "$sql_is_unique" | tr -d '[[:space:]]'`
if [[ "$is_unique" == "f" ]]; then
	echo "ERROR: Column tbl_id NOT UNIQUE!"; exit 1
fi
source "$DIR/includes/check_status.sh"	

#########################################################################
# Transfer results to original tables
#########################################################################

echoi $e "- Updating NSR results columns in table:"

echoi $e -n "-- view_full_occurrence_individual_dev..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/update_nsr_results_vfoi.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "-- agg_traits..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/update_nsr_results_agg_traits.sql
source "$DIR/includes/check_status.sh"	

# Comment out remainder for now, but should probably remove completely
# These tables should be deleted at completion of entire pipeline, 
# after all validations complete and no issues discovered

# echoi $e -n "- Removing temporary tables..."
# sql="
# -- DROP TABLE IF EXISTS nsr_submitted; 
# -- DROP TABLE IF EXISTS nsr_submitted_raw;
# "
# PGOPTIONS='--client-min-messages=warning' psql $db_private $user -q << EOF
# \set ON_ERROR_STOP on
# SET search_path TO $dev_schema;
# $sql
# EOF
# source "$DIR/includes/check_status.sh"	

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi

######################################################
# End script
######################################################