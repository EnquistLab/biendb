#!/bin/bash

#########################################################################
# Purpose: Builds endangered species tables and extract unique taxa for
# 	scrubbing by TNRS
#
# Authors: Brad Boyle (bboyle@email.arizona.edu)
# Date created: 25 Nov. 2016
# Date first release: 
#########################################################################

# Enable the following for strict debugging only:
#set -e

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
# $local_basename = name of this file minus ='.sh' extension
# $local_basename should be same as containing directory, as  
# well as local data subdirectory within main data directory, 
# if local data directory needed
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
# Import endangered species tables
#########################################################################

# Create main traits table and raw trait data table
echoi $i -n "- Creating tables..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema_adb_private -f $DIR_LOCAL/sql/create_tables.sql
source "$DIR/includes/check_status.sh"	

# Import the raw data
# Note use of limit for testing
echoi $i -n "- Importing raw data..."
if [ $use_limit = "true" ]; then 
	head -n $recordlimit $data_dir_local/$raw_traits_file | psql $db_private $user -q -c "COPY ${dev_schema_adb_private}.traits_raw FROM STDIN  DELIMITER ',' CSV NULL AS 'NA' HEADER"
else
	sql="\COPY traits_raw FROM '${data_dir_local}/${raw_traits_file}' DELIMITER ',' CSV NULL AS 'NA' HEADER;"
	PGOPTIONS='--client-min-messages=warning' psql $db_private $user -q << EOF
	\set ON_ERROR_STOP on
	SET search_path TO $dev_schema_adb_private;
	$sql
EOF
fi
source "$DIR/includes/check_status.sh"	

echoi $e "-- Setting empty strings to null:"
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -c "SELECT public.f_empty2null('${dev_schema_adb_private}.traits_raw')" > /dev/null >> $tmplog
source "$DIR/includes/check_status.sh"

# Insert raw data
echoi $i -n "- Inserting raw data..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema_adb_private -f $DIR_LOCAL/sql/insert_raw.sql
source "$DIR/includes/check_status.sh"	

# Correct raw data
echoi $i -n "- Correcting serious name errors in raw data..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema_adb_private -f $DIR_LOCAL/sql/correct_raw.sql
source "$DIR/includes/check_status.sh"	

#########################################################################
# extract taxa for standardization with TNRS
#########################################################################

echoi $i -n "- Extracting verbatim taxa..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema_adb_private -f $DIR_LOCAL/sql/create_taxon_verbatim.sql

sql="\COPY (SELECT taxon_verbatim_id, taxon_verbatim FROM taxon_verbatim) TO '${data_dir_local}/data/taxon_verbatim.csv' DELIMITER ','"
PGOPTIONS='--client-min-messages=warning' psql $db_private $user -q << EOF
\set ON_ERROR_STOP on
SET search_path TO $dev_schema_adb_private;
$sql
EOF
source "$DIR/includes/check_status.sh"	

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi

######################################################
# End script
######################################################
