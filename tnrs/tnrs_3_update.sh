#!/bin/bash

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

#########################################################################
# Main
#########################################################################
: <<'COMMENT_BLOCK_x'
COMMENT_BLOCK_x

modname=`basename "$BASH_SOURCE"`
echoi $e "Executing module '$modname'"

#########################################################################
# Import TNRS results 
#########################################################################

echoi $e -n "- Creating TNRS results tables..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/create_tnrs_results_tables.sql
source "$DIR/includes/check_status.sh"	

echoi $e "- Preparing TNRS results file for import:"

## Unpack from tarball so have unmodified original results file
# echoi $e -n "-- Extracting tarball to '$data_dir_local/$tnrs_scrubbed_filename'"
# tar -xzf $data_dir_local/$tnrs_scrubbed_filename".tar.gz" -C $data_dir_local/
# source "$DIR/includes/check_status.sh"	

# Remove all double quotes so they do not interfere with upload.
# Quotes in original name can be restored from file tnrs_submitted
echoi $e -n "-- Removing all double quotes..."
sed -i 's/"//g' $data_dir_local/$tnrs_scrubbed_filename 
source "$DIR/includes/check_status.sh"	

# Import the file
# Note the specification of non-existent double quote delimiter
echoi $i -n "- Importing TNRS resolution results from file '$tnrs_scrubbed_filename'..."
sql="\COPY tnrs_scrubbed FROM '${data_dir_local}/${tnrs_scrubbed_filename}' WITH CSV HEADER DELIMITER E'\t' QUOTE E'\"' NULL AS '';"
PGOPTIONS='--client-min-messages=warning' psql $db_private $user -q << EOF
\set ON_ERROR_STOP on
SET search_path TO $dev_schema;
$sql
EOF
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Setting empty strings to null..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -c "SELECT public.f_empty2null('${dev_schema}.tnrs_scrubbed')" > /dev/null >> $tmplog
source "$DIR/includes/check_status.sh"

#########################################################################
# Post-process TNRS results
#########################################################################

echoi $e -n "- Separating records with compound ids..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/fix_compound_ids.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Fixing additional issues caused by TNRSbatch..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/fix_tnrs_scrubbed.sql
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

echoi $e -n "- Updating TNRS warnings..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/update_tnrs_warnings.sql
source "$DIR/includes/check_status.sh"

# Check that candidate pkey field poldiv_full is still unique
# Throw error and abort if not
echoi $e -n " - Verifying candidate primary key unique:"
check_pk -u $user -d $db -s $dev_schema -t tnrs -c name_submitted_verbatim

#currscript=`basename "$0"`; echo "EXITING script $currscript"; exit 0

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi

######################################################
# End script
######################################################