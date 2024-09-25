#!/bin/bash

#########################################################################
# Purpose:	Creates analytical table bien_species_all
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

: <<'COMMENT_BLOCK_1'
COMMENT_BLOCK_1

######################################################
# Taxon embargoes
#  
# Must do this first to produce index-free copies of
# analytical_stem and vfoi; otherwise following steps
# will be too slow and may crash
######################################################

echoi $e -n "- Applying taxon embargoes..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_public --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/taxon_embargoes.sql
source "$DIR/includes/check_status.sh"

######################################################
# Drop indexes on remaining tables to be embargoed
######################################################

echoi $e -n "- Dropping indexes..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_public --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/drop_indexes.sql
source "$DIR/includes/check_status.sh"

######################################################
# Add temporary indexes needed for delete operations
######################################################

echoi $e -n "- Adding temporary indexes..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_public --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/add_temporary_indexes.sql
source "$DIR/includes/check_status.sh"

######################################################
# Dataset-level embargoes
######################################################

echoi $e "- Applying dataset embargoes:"

echoi $e -n "-- Madidi..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_public --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/remove_madidi.sql
source "$DIR/includes/check_status.sh"

echoi $e -n "-- REMIB..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_public --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/remove_remib.sql
source "$DIR/includes/check_status.sh"

echoi $e -n "-- NVS..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_public --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/remove_nvs.sql
source "$DIR/includes/check_status.sh"

# Temporary fix for BIEN 4.0 only!
# Replace with 'filter_rainbio.sql' when data providers have been
# disambiguated
echoi $e -n "-- rainbio..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_public --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/remove_rainbio.sql
source "$DIR/includes/check_status.sh"

echoi $e -n "-- Non-public traits..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_public --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/remove_nonpublic_traits.sql
source "$DIR/includes/check_status.sh"

echoi $e -n "-- Traits with <$sp_count_min species..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_public --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -v sp_count_min=$sp_count_min -f $DIR_LOCAL/sql/traits_species_count_embargo.sql
source "$DIR/includes/check_status.sh"

######################################################
# Update metadata
######################################################

echoi $e "- Updating metadata:"

echoi $e -n "-- Removing deleted datasources from metadata tables..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_public --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/update_datasources.sql
source "$DIR/includes/check_status.sh"

echoi $e -n "-- Updating taxon counts..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_public --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/update_bien_taxonomy.sql
source "$DIR/includes/check_status.sh"

######################################################
# Echo final instructions if running solo
######################################################

if [ -z ${master+x} ]; then

msg_next_steps="$(cat <<-EOF

Script completed. 

Next steps:

1. Finish updating remaining metadata tables
2. Restore indexes & permissions on tables vfoi and agg_traits

EOF
)"
echoi $e "$msg_next_steps"

fi

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi


