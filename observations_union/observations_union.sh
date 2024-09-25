#!/bin/bash

#########################################################################
# Purpose: Creates and populates table observations_union in development
# 	analytical schema.
#
# WARNING: Requires parameters $db, $dev_schema and $tbl_vfoi
#
# Authors: Brad Boyle (bboyle@email.arizona.edu)
# Date created: 17 May 2017
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
source "$DIR/includes/local_params.sh"	

#########################################################################
# Params
#########################################################################

# Reset process name here if applicable
pname_local=$pname_local

#########################################################################
# Main
#########################################################################

# Confirm operation
pname_local_header="BIEN notification: process '"$pname_local"'"
source "$DIR/includes/local_confirm.sh"	

#########################################################################
# Main
#########################################################################

echoi $e "Executing module '$local_basename'"

: <<'COMMENT_BLOCK_x'
COMMENT_BLOCK_x

######################################################
# Create tables in private analytical db
######################################################

echoi $e "- Creating table observations_union in private database:"

echoi $e -n "-- Creating temp table observations_all..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -v tbl_vfoi=$tbl_vfoi -v sql_where_default="$SQL_WHERE_DEFAULT" -v limit="$limit" -f $DIR_LOCAL/sql/create_observations_all.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "-- Updating geometry column in observations_all..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/add_geometry_observations_all.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "-- Creating & populating table observations_union..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/create_observations_union.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "-- Altering table observations_union (adding species_std, is_embargoed)..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/alter_observations_union.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "-- Creating & populating table species..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -v tbl_vfoi=$tbl_vfoi -v sql_where_default="$SQL_WHERE_DEFAULT" -v limit="$limit" -f $DIR_LOCAL/sql/create_species.sql
source "$DIR/includes/check_status.sh"	

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi

######################################################
# End script
######################################################