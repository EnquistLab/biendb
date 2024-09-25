#!/bin/bash

#########################################################################
# Purpose: Calculate point geometry from latitude and longitude for table
#			view_full_occurrence_individual
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

echoi $e "Executing module '$local_basename':"

: <<'COMMENT_BLOCK_1'
COMMENT_BLOCK_1

# Constrain geometries to avoid erroneous coordinates
# Needs to be done first to prevent calculating erroneous geometries
echoi $i -n "- Enforcing geometric constraints..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/constrain_geometries.sql 
source "$DIR/includes/check_status.sh"

# Add additional non-spatial indexes needed for updates
# Also fix any species names containing single quotes
echoi $i -n "- Building non-spatial indexes needed for next step..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/index_vfoi.sql 
source "$DIR/includes/check_status.sh"

# Extract distinct species
# where latitude and longitude are not null
# Option -t suppresses headers and footers in query
echoi $i -n "- Exporting species list..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -t -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/georeferenced_species.sql > $data_dir_local/georeferenced_species.txt
source "$DIR/includes/check_status.sh"

# A hack to avoid crashing the next steps
# Names with single quotes won't match, but who cares?
echoi $i -n "- Removing single quotes from species names..."
sed -i "s/'//g" $data_dir_local/georeferenced_species.txt
source "$DIR/includes/check_status.sh"

echoi $i -n "- Calculating geometries by species..."
while read SPECIES
do
	PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q  -c "UPDATE ${dev_schema}.view_full_occurrence_individual_dev SET geom = ST_GeomFromText('POINT(' || longitude || ' ' || latitude || ')',4326) WHERE  (scrubbed_species_binomial IS NOT NULL AND latitude IS NOT NULL AND longitude IS NOT NULL) AND scrubbed_species_binomial = '${SPECIES}'"
done < $data_dir_local/georeferenced_species.txt
source "$DIR/includes/check_status.sh"

# Index the geometry column
echoi $i -n "- Indexing geometry column..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/index_geom.sql 
source "$DIR/includes/check_status.sh"

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi



