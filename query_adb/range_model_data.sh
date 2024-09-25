#!/bin/bash

#########################################################################
# Purpose: Extract raw data for BIEN range models
#
# Requires table species_observation_counts_crosstab, prepared by 
#	running script query_species.sh, in this directory.
#
# Author: Brad Boyle (bboyle@email.arizona.edu)
#########################################################################

# Comment-block tags - Use for all temporary comment blocks

#### TEMP ####
# echo "WARNING: portions of script `basename "$BASH_SOURCE"` commented out!"
## Other temporary code to be executed before comment block
## Start comment block
# : <<'COMMENT_BLOCK_xxx'

## End comment block
# COMMENT_BLOCK_xxx
## Temporary code to be executed after comment block
#### TEMP ####

## Exit all scripts
# echo "EXITING script `basename "$BASH_SOURCE"`"; exit 0

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

# Set parent directory if running independently & suppress main message
if [ -z ${master+x} ]; then
	DIR=$DIR_LOCAL"/.."
	suppress_main='true'
else
	suppress_main='false'
fi

# Load startup script for local files
# Sets remaining parameters and options, and issues confirmation
# and startup messages
source "$DIR/includes/startup_local.sh"	

######################################################
# Custom confirmation message. 
# Will only be displayed if running as
# standalone script and -s (silent) option not used.
######################################################

if [[ "$i" = "true" && -z ${master+x} ]]; then 

	# Reset confirmation message
	msg_conf="$(cat <<-EOF

	Process '$pname' will use following parameters: 
	
	Database:	$db
	Schema:		$sch
	vfoi:		$vfoi
	obs_threshold:	$obs_threshold
	
EOF
	)"		
	confirm "$msg_conf"
fi

######################################################
# WHERE clauses
######################################################

# Base where clause
# all other filters added to this one
# Do NOT include WHERE
base_where=" scrubbed_species_binomial IS NOT NULL AND higher_plant_group IN ('bryophytes', 'ferns and allies','flowering plants','gymnosperms (conifers)', 'gymnosperms (non-conifer)') AND is_location_cultivated IS NULL AND is_invalid_latlong=0 AND is_geovalid = 1 AND (is_cultivated_observation = 0 OR is_cultivated_observation IS NULL) AND (georef_protocol is NULL OR georef_protocol<>'county_centroid') AND (is_centroid IS NULL OR is_centroid=0) AND ( EXTRACT(YEAR FROM event_date)>=1970 OR event_date IS NULL ) "

# Addition WHERE citeria to add to the base where clasue
optional_where="AND (is_introduced=0 OR is_introduced IS NULL) AND observation_type IN ('plot','specimen','literature','checklist')  "

full_where="${base_where} ${optional_where}"

#########################################################################
# Main
#########################################################################

echoi $e "Executing module '$local_basename'"
echoi $e " "

######################################################
# Run the queries, changing where clause each time
######################################################

echoi $e -n "Extracting table of common species..."
sql_where=$full_where
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch="$sch" -v vfoi=$vfoi -v sql_where="$sql_where" -v obs_threshold=$obs_threshold -f $DIR_LOCAL/sql/rmd_common.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "Inserting rare species..."
sql_where=$base_where
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch="$sch" -v vfoi=$vfoi -v sql_where="$sql_where" -v obs_threshold=$obs_threshold -f $DIR_LOCAL/sql/rmd_rare.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "Creating metadata table..."
sql_where=$base_where
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch="$sch" -f $DIR_LOCAL/sql/rmd_metadata.sql
source "$DIR/includes/check_status.sh"	

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi