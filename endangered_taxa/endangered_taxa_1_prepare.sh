#!/bin/bash

#########################################################################
# Purpose: Builds endangered species tables and extract unique taxa for
# 	scrubbing by TNRS
#
# Authors: Brad Boyle (bboyle@email.arizona.edu)
# Date created: 25 Nov. 2016
# Date first release: 
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

: <<'COMMENT_BLOCK_1'
COMMENT_BLOCK_1

#########################################################################
# Main
#########################################################################

echoi $e "Executing module '$local_basename'"

#########################################################################
# Import endangered species tables
#########################################################################

echoi $i "- Building endangered species tables:"

# Create partial index on species column and extract distinct species
# names where latitude and longitude are not null
# Option -t suppresses headers and footers in query
echoi $i -n "- Creating tables..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/create_tables.sql
source "$DIR/includes/check_status.sh"	

# Import the raw data
echoi $i -n "- Importing data for 'cites', "
sql="\COPY cites FROM '${data_dir_local}/cites.csv' DELIMITER ',' CSV HEADER;"
PGOPTIONS='--client-min-messages=warning' psql $db_private $user -q << EOF
\set ON_ERROR_STOP on
SET search_path TO $dev_schema;
$sql
EOF

echoi $i -n "'iucn', "
sql="\COPY iucn FROM '${data_dir_local}/iucn.csv' DELIMITER ',' CSV HEADER;"
PGOPTIONS='--client-min-messages=warning' psql $db_private $user -q << EOF
\set ON_ERROR_STOP on
SET search_path TO $dev_schema;
$sql
EOF

echoi $i -n "'usda'..."
sql="\COPY usda FROM '${data_dir_local}/usda.csv' DELIMITER ',' CSV HEADER;"
PGOPTIONS='--client-min-messages=warning' psql $db_private $user -q << EOF
\set ON_ERROR_STOP on
SET search_path TO $dev_schema;
$sql
EOF
source "$DIR/includes/check_status.sh"	

# Combine verbatim taxon names and source status into single table
echoi $i -n "- Combining endangered taxon data into single table..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/populate_endangered_taxa_by_source.sql
source "$DIR/includes/check_status.sh"	

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi

######################################################
# End script
######################################################
