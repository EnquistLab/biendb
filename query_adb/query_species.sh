#!/bin/bash

#########################################################################
# Purpose: Runs specues queries on analytical database
#
# NOTE: Count of observation are cumulative, as each successive filter
# is added to all previous filters
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

# Base where clause
# all other filters added to this one
# include WHERE
base_where="WHERE scrubbed_species_binomial IS NOT NULL AND higher_plant_group IN ('bryophytes', 'ferns and allies','flowering plants','gymnosperms (conifers)', 'gymnosperms (non-conifer)') AND is_location_cultivated IS NULL AND is_invalid_latlong=0 AND tnrs_name_matched_score>=0.53 "

# Addition WHERE citeria to add to the base where clasue
# Each goes on its own line (no internal line breaks!)
# In addition, each query criterio is followed by pipe (|) plus nickname
# Nickname should be name of main column in query
# Escape single quotes in filter with backslash
wheres="
AND is_geovalid = 1 | is_geovalid
AND (is_cultivated_observation = 0 OR is_cultivated_observation IS NULL) | is_cultivated_observation
AND (georef_protocol is NULL OR georef_protocol<>\'county_centroid\') | georef_protocol
AND (is_centroid IS NULL OR is_centroid=0) | is_centroid
AND ( EXTRACT(YEAR FROM event_date)>=1970 OR event_date IS NULL ) | year>=1970
AND (is_introduced=0 OR is_introduced IS NULL) | is_introduced
AND observation_type IN (\'plot\',\'specimen\',\'literature\',\'checklist\') | observation_type
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
#check_tbl="vfoi_temp"
echoi $e "Table: $check_tbl"

# Create table and get base count
sql_where=$base_where
name_where="1. Base filter"
echoi $e -n "Filter '${name_where}'..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch="$sch" -v check_tbl="$check_tbl" -v sql_where="$sql_where" -v name_where="$name_where" -f $DIR_LOCAL/sql/species_observation_counts_create.sql
source "$DIR/includes/check_status.sh"	


# Run filtered queries
fno=1
IFSbak=$IFS
IFS=$'\n'
for where in $wheres; do
	fno=$(($fno + 1))
	IFS="|"
	arr_where=($where)
	sql_where_part=${arr_where[0]}
	name_where=${arr_where[1]}
	IFS=$IFSbak
	sql_where_part=$(echo "$sql_where_part" | xargs)
	name_where=$(echo "$name_where" | xargs)
	name_where=$fno". "$name_where
	sql_where=$sql_where" "$sql_where_part
	echoi $e -n "Filter:'${name_where}'..."
	#echoi $e "Filter: '${sql_where_part}'"
	#echoi $e "Full filter: '${sql_where}'"
	PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch="$sch" -v check_tbl="$check_tbl" -v sql_where="$sql_where" -v name_where="$name_where" -f $DIR_LOCAL/sql/species_observation_counts_insert.sql
	source "$DIR/includes/check_status.sh"	
	IFS=$'\n'
done
IFS=$IFSbak

echoi $e -n "Creating crosstab..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch="$sch" -f $DIR_LOCAL/sql/species_observation_counts_crosstab.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "Indexing crosstab table..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch="$sch" -f $DIR_LOCAL/sql/species_observation_counts_crosstab_index.sql
source "$DIR/includes/check_status.sh"	

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi