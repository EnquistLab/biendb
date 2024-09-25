#!/bin/bash
#########################################################################
# Purpose: Import & post_process CDS results
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
# Import CDS results 
#########################################################################

echoi $e -n "- Creating CDS results table..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/create_cds.sql
source "$DIR/includes/check_status.sh"	

# Hack until fix errors in validation app
echoi $i "- Fixing errors in raw CDS validation result file:"
echoi $i -n "-- Extra header row..."
sed -i '/^,latitude_verbatim/d' "${validation_app_data_dir}/${results_filename}"
source "$DIR/includes/check_status.sh"	
echoi $i -n "-- Missing trailing delimiters for erroneous coordinates..."
sed -i 's/One or more missing coordinates$/One or more missing coordinates,,/g' "${validation_app_data_dir}/${results_filename}"
source "$DIR/includes/check_status.sh"	

echoi $i -n "- Importing CDS validation results..."
sql="\COPY cds FROM '${validation_app_data_dir}/${results_filename}' DELIMITER ',' CSV HEADER;"
PGOPTIONS='--client-min-messages=warning' psql $db_private $user -q << EOF
\set ON_ERROR_STOP on
SET search_path TO $dev_schema;
$sql
EOF
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Populating primary and foreign keys..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/alter_cds.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Indexing CDS results table..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/index_cds.sql
source "$DIR/includes/check_status.sh"	

# Check that candidate pkey field poldiv_full is still unique
# Throw error and abort if not
echoi $e "Verifying candidate primary key unique:"
check_pk -u $user -d $db_private -s $dev_schema -t cds -c latlong_verbatim

#########################################################################
# Update CDS results columns in original tables
#########################################################################

echoi $e "- Updating CDS results columns in table:"

echoi $e -n "-- view_full_occurrence_individual_dev..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -v REL_DIST_MAX=$REL_DIST_MAX -f $DIR_LOCAL/sql/cds_update_vfoi.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "-- agg_traits..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -v REL_DIST_MAX=$REL_DIST_MAX -f $DIR_LOCAL/sql/cds_update_traits.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "-- plot_metadata..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -v REL_DIST_MAX=$REL_DIST_MAX -f $DIR_LOCAL/sql/cds_update_plot_metadata.sql
source "$DIR/includes/check_status.sh"	

# echoi $e -n "-- ih..."
# PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/cds_update_ih.sql
# source "$DIR/includes/check_status.sh"	

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi

######################################################
# End script
######################################################