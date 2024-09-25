#!/bin/bash

#########################################################################
# Purpose: Runs queries on analytical database
#
# Notes:
#	1. Results echoed onscreen and saved to log file in log/
#  
# Author: Brad Boyle (bboyle@email.arizona.edu)
#########################################################################

: <<'COMMENT_BLOCK_x'
COMMENT_BLOCK_x
#echoi $e; echoi $e "EXITING script `basename "$BASH_SOURCE"`"; exit 0

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
	
EOF
	)"		
	confirm "$msg_conf"
fi

######################################################
# WHERE clauses
######################################################

# Each WHERE clause on it's own line (no internal line breaks!)
wheres="
WHERE scrubbed_species_binomial IS NOT NULL
WHERE observation_type IN ('plot','specimen','literature','checklist')
WHERE is_geovalid = 1
WHERE (georef_protocol is NULL OR georef_protocol<>'county centroid')
WHERE (is_centroid IS NULL OR is_centroid=0)
WHERE higher_plant_group IN ('bryophytes', 'ferns and allies','flowering plants','gymnosperms (conifers)', 'gymnosperms (non-conifer)')
WHERE (is_introduced=0 OR is_introduced IS NULL)
WHERE is_location_cultivated IS NULL
WHERE (is_cultivated_observation = 0 OR is_cultivated_observation IS NULL)
WHERE scrubbed_species_binomial IS NOT NULL AND observation_type IN ('plot','specimen','literature','checklist') AND is_geovalid = 1 AND (georef_protocol is NULL OR georef_protocol<>'county centroid') AND higher_plant_group IN ('bryophytes', 'ferns and allies','flowering plants','gymnosperms (conifers)', 'gymnosperms (non-conifer)') AND (is_introduced=0 OR is_introduced IS NULL) AND is_location_cultivated IS NULL
WHERE scrubbed_species_binomial IS NOT NULL AND observation_type IN ('plot','specimen','literature','checklist') AND is_geovalid = 1 AND (georef_protocol is NULL OR georef_protocol<>'county centroid') AND (is_centroid IS NULL OR is_centroid=0) AND higher_plant_group IN ('bryophytes', 'ferns and allies','flowering plants','gymnosperms (conifers)', 'gymnosperms (non-conifer)') AND (is_introduced=0 OR is_introduced IS NULL) AND is_location_cultivated IS NULL AND (is_cultivated_observation = 0 OR is_cultivated_observation IS NULL)
"

#########################################################################
# Main
#########################################################################

echoi $e "Executing module '$local_basename'"
echoi $e " "

######################################################
# Run the queries, changing where clause each time
######################################################

check_tbl=$vfoi
echoi $e "Table: $check_tbl"

# Return all records and save total 
sql_where=""
echoi $e "  Filter: [All rows]:"
ret=`psql -U $user -d $db -qt -v sch="$sch" -v check_tbl="$check_tbl" -v sql_where="$sql_where" -f "sql/check_tbl_where.sql" | tr -d '[[:space:]]'`
tot=$ret
echoi $e "  - Rows returned: $ret"
echoi $e "  - Rows filtered: 0"

# Run filtered queries
IFSbak=$IFS
IFS=$'\n'
for where in $wheres; do
	sql_where=$where
	echoi $e "Filter: '${sql_where}'"
	ret=`psql -U $user -d $db -qt -v sch="$sch" -v check_tbl="$check_tbl" -v sql_where="$sql_where" -f "sql/check_tbl_where.sql" | tr -d '[[:space:]]'`
	echoi $e "- Rows returned: $ret"
	echoi $e "- Rows filtered: $(($tot-$ret))"
done
IFS=$IFSbak

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi