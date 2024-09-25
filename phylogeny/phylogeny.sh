#!/bin/bash

#################################################################
# Purpose: Creates table phylogeny and adds metadata and newick
#    format phylogenies.
# Authors: Brad Boyle (bboyle@email.arizona.edu)
# Date created: 27 June 2016
#################################################################

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

echoi $e "Executing module 'phylogeny'"

# Create the tables
echoi $e -n "- Creating tables..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/create_tables.sql
source "$DIR/includes/check_status.sh"	

# Import metadata file to temp table
echoi $i -n "- Importing metadata to temporary table..."
sql="
\COPY phylo_info FROM '${data_dir_local}/${meta_file}' DELIMITER ',' CSV HEADER;
"
PGOPTIONS='--client-min-messages=warning' psql $db_private $user -q << EOF
\set ON_ERROR_STOP on
SET search_path TO $dev_schema;
$sql
EOF
echoi $i "done"

# Make some adjustments and load metadata to table phylogeny
# Also drops the temporary table
echoi $i -n "- Inserting metadata..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/load_metadata.sql
source "$DIR/includes/check_status.sh"	

# Load phylogenies
echoi $i -n "- Loading phylogenies..."
#echoi $i "- Loading phylogenies:"
for f in $data_dir_local/*.$phylo_file_suffix
do
	fname="${f##*/}"
	#echoi $i "-- Inserting file $fname"
	fcontents=`cat $f`
	sql="
	UPDATE phylogeny
	SET phylogeny='$fcontents'
	WHERE filename='$fname'
	;
	"
	PGOPTIONS='--client-min-messages=warning' psql $db_private $user -q << EOF
	\set ON_ERROR_STOP on
	SET search_path TO $dev_schema;
	$sql
EOF
done
source "$DIR/includes/check_status.sh"	

# Finish up
echoi $i -n "- Indexing table phylogeny & adjusting ownership..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/add_indexes.sql
source "$DIR/includes/check_status.sh"	

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi

######################################################
# End script
######################################################