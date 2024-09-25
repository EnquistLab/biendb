#!/bin/bash

#########################################################################
# Purpose: Import TNRS results, merges with endangered species reference
#	tables
#
# Authors: Brad Boyle (bboyle@email.arizona.edu)
# Date created: 25 Nov. 2016
# Date first release: 24 Mar 2017
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

echoi $e "Executing module 'endangered_species_2'"

#########################################################################
# Update TNRS results to endangered taxa master table
#########################################################################

echoi $e -n "- Populating table endangered_taxa..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/endangered_taxa.sql
source "$DIR/includes/check_status.sh"	

#########################################################################
# Extract table of USDA state-specific endangered species
#########################################################################

echoi $e -n "- Extracting state-specific endangered species..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/state_endangered_species.sql
source "$DIR/includes/check_status.sh"	

#########################################################################
# Update view_full_occurrencer_individual_dev
#########################################################################

# family embargoes
echoi $e -n "- Updating family embargoes..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/family_embargoes_vfoi.sql
source "$DIR/includes/check_status.sh"	

# genus embargoes
echoi $e -n "- Updating genus embargoes..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/genus_embargoes_vfoi.sql
source "$DIR/includes/check_status.sh"	

# species embargoes
echoi $e -n "- Updating species embargoes..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/species_embargoes_vfoi.sql
source "$DIR/includes/check_status.sh"	

# subspecies embargoes
echoi $e -n "- Updating subspecies embargoes..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/subspecies_embargoes_vfoi.sql
source "$DIR/includes/check_status.sh"	

# Create and populate column is_embargoed
echoi $e -n "- Adding column 'is_embargoed' to table 'taxon'..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/update_endangered_taxa.sql
source "$DIR/includes/check_status.sh"	

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi

######################################################
# End script
######################################################