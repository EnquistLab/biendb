#!/bin/bash

#########################################################################  
# Purpose: Creates analytical table bien_summary  
#  
# Usage:   
#		$ ./create_datasource.sh [options]  
#    
# Purpose:  
# Create table bien_summary, containing count of observations, plots,  
# species, and other high-level metadata for the BIEN database. This  
# table is used for displaying online summaries on the BIEN website.  
#
# Authors: Brad Boyle (bboyle@email.arizona.edu)  
# Date created: 11 Feb. 2017  
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

#########################################################################
# Main
#########################################################################

echoi $e "Executing module '$local_basename'"


######################################################
# Create table data_contributors in development schema
######################################################

echoi $i -n "- Creating table data_contributors..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/create_tables.sql
source "$DIR/includes/check_status.sh"	
	
######################################################
# Insert providers
######################################################

echoi $i -n "- Inserting providers..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/insert_providers.sql
source "$DIR/includes/check_status.sh"	

######################################################
# Populate additional metadata for herbaria
######################################################

echoi $i -n "- Populating additional metadata for herbaria..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/herbarium_metadata.sql
source "$DIR/includes/check_status.sh"	

######################################################
# Populate proximate providers table
######################################################

echoi $i -n "- Populatingproximate providers..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/proximate_providers.sql
source "$DIR/includes/check_status.sh"	


: <<'COMMENT_BLOCK_1'
# Shouldn't need any of the following
# Delete after confirm results

######################################################
# Populate observation counts & fix duplicate records bug
######################################################

echoi $i -n "- Calculating observations..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/count_observations.sql

source "$DIR/includes/check_status.sh"	

echoi $i -n "- Fixing duplicate records..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/fix_duplicates.sql
source "$DIR/includes/check_status.sh"	


COMMENT_BLOCK_1




# Index final table 
echoi $i -n "- Indexing table..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/build_indexes.sql
source "$DIR/includes/check_status.sh"	

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi

######################################################
# End script
######################################################
