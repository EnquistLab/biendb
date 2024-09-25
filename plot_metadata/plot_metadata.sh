#!/bin/bash

#########################################################################
# Purpose: Creates analytical table plot_metadata
#
# Usage: 
#		$ ./plot_metadata.sh [options]
#  
# Warning #1:
# 	This information was largely omitted from the core database and must
# 	therefore be extracted from CSV files extracted from manually prepared
# 	spreadsheets.
# 
# Warning #2:
# 	This version currently works only on public_vegbien. Once all 
#	modifications currently restricted to public_vegbien have been
#	transferred over to vegbien, the operations in this script should
# 	only be carried out on vegbien.vfoi. The public version would be
# 	simply a copy of this, with embargoed records removed.
#
# Authors: Brad Boyle (bboyle@email.arizona.edu)
# Date created: 17 Sept. 2016
# First release: 
# Database version at first release: 
#########################################################################

# Wrap any section you do not want to run in comment blocks. 
# Additional comment wrappers must have different comment
# block name, e.g., COMMENT_BLOCK_2
: <<'COMMENT_BLOCK_1'
COMMENT_BLOCK_1

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

# Create table plot_metadata
echoi $i -n "- Creating table plot_metadata..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/create_plot_metadata.sql
source "$DIR/includes/check_status.sh"	

echoi $i -n "- Updating existing metadata..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/update_existing_metadata.sql
source "$DIR/includes/check_status.sh"	

######################################################
# Import metadata files
######################################################

echoi $i -n "- Creating source-specific metadata tables..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/create_metadata_tables.sql
source "$DIR/includes/check_status.sh"	

echoi $i -n "- Importing CVS metadata file..."
sql="
\COPY metadata_cvs FROM '${data_dir_local}/${meta_file_cvs}' DELIMITER ',' CSV HEADER;
"
PGOPTIONS='--client-min-messages=warning' psql $db_private $user -q << EOF
\set ON_ERROR_STOP on
SET search_path TO $dev_schema;
$sql
EOF
source "$DIR/includes/check_status.sh"	

echoi $i -n "- Importing VegBank metadata file..."
sql="
\COPY metadata_vegbank FROM '${data_dir_local}/${meta_file_vegbank}' DELIMITER E'\t' CSV HEADER;
"
PGOPTIONS='--client-min-messages=warning' psql $db_private $user -q << EOF
\set ON_ERROR_STOP on
SET search_path TO $dev_schema;
$sql
EOF
source "$DIR/includes/check_status.sh"	

echoi $i -n "- Importing BIEN2 metadata file..."
sql="
\COPY metadata_bien2 FROM '${data_dir_local}/${meta_file_bien2}' DELIMITER E'\t' CSV HEADER;
"
PGOPTIONS='--client-min-messages=warning' psql $db_private $user -q << EOF
\set ON_ERROR_STOP on
SET search_path TO $dev_schema;
$sql
EOF
source "$DIR/includes/check_status.sh"	

######################################################
# Update metadata
######################################################

echoi $i -n "- Updating CVS metadata..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/update_cvs_metadata.sql
source "$DIR/includes/check_status.sh"	

echoi $i -n "- Updating VegBank metadata..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/update_vegbank_metadata.sql
source "$DIR/includes/check_status.sh"	

echoi $i -n "- Updating BIEN2 metadata..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/update_bien2_metadata.sql
source "$DIR/includes/check_status.sh"	

echoi $i -n "- Updating remaining metadata..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/update_metadata_general.sql
source "$DIR/includes/check_status.sh"	

echoi $i -n "- Standardizing constrained vocabulary..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/standardize_values.sql
source "$DIR/includes/check_status.sh"	

# Drop temporary metadata tables
echoi $i -n "- Dropping temporary tables..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/drop_temporary_tables.sql
source "$DIR/includes/check_status.sh"	

######################################################
# Add remaining indexes
######################################################

echoi $i -n "- Building remaining indexes..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/index_plot_metadata.sql
source "$DIR/includes/check_status.sh"	

#########################################################################
# Add foreign key to table vfoi
#########################################################################

echoi $i "- Adding foreign key to table 'view_full_occurrence_individual':"

# Index columns that will be used to join to plot_metadata
echoi $i -n "-- Indexing candidate key columns..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/index_candidate_keys.sql
source "$DIR/includes/check_status.sh"	

# Populate foreign key
# Also removes 'plot names' erroneously populated with GIBF IDs  
# during building of core db
echoi $i -n "-- Populating FK column 'plot_metadata_id'..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/populate_fkey.sql
source "$DIR/includes/check_status.sh"	

#########################################################################
# Add foreign key to table analytical_stem
#########################################################################

echoi $i -n "- Adding foreign key to table 'analytical_stem'..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/update_fk_analytical_stem.sql
source "$DIR/includes/check_status.sh"	

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi

######################################################
# End script
######################################################
