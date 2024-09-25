#!/bin/bash

#########################################################################
# Purpose: Updates PDG results missed due to PDG glitch
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
	
	Database:				$db_private
	Schema:					$sch
	
EOF
	)"		
	confirm "$msg_conf"
fi

#########################################################################
# Main
#########################################################################

echoi $e "Executing module '$local_basename'"

: <<'COMMENT_BLOCK_1'

echoi $e -n "Indexing table pdg..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$sch -f "sql/index_pdg.sql"
source "$DIR/includes/check_status.sh"

echoi $e -n "Backing up geovalid columns..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$sch -f "sql/backup_geovalid_cols.sql"
source "$DIR/includes/check_status.sh"

echoi $e "--------------------------------------------"
echoi $e "Updating table \"analytical_stem\" for country:"
while read ctry; do
	echoi $e -n "- $ctry..."
	sql="UPDATE ${sch}.analytical_stem a SET is_in_country=b.is_in_country, 	is_in_state_province=b.is_in_state_province, is_in_county=b.is_in_county, is_geovalid=b.is_geovalid FROM ${sch}.pdg b WHERE a.country='${ctry}' AND a.is_geovalid_issue IS NULL AND a.is_geovalid IS NULL AND b.country='${ctry}' AND b.tbl_name='view_full_occurrence_individual' AND a.taxonobservation_id=b.tbl_id;"
	#echo; echo $sql; echo
	PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -c "$sql"
	source "$DIR/includes/check_status.sh"
done < countries

COMMENT_BLOCK_1


echoi $e "--------------------------------------------"
echoi $e "Updating table \"agg_traits\" for country:"
while read ctry; do
	echoi $e -n "- $ctry..."
	sql="UPDATE ${sch}.agg_traits a SET is_in_country=b.is_in_country, 	is_in_state_province=b.is_in_state_province, is_in_county=b.is_in_county, is_geovalid=b.is_geovalid FROM ${sch}.pdg b WHERE a.country='${ctry}' AND a.is_geovalid_issue IS NULL AND a.is_geovalid IS NULL AND b.country='${ctry}' AND b.tbl_name='agg_traits' AND a.id=b.tbl_id;"
	PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -c "$sql"
	source "$DIR/includes/check_status.sh"
done < countries

echoi $e "--------------------------------------------"
echoi $e "Updating table \"view_full_occurrence_individual\" for country:"
while read ctry; do
	echoi $e -n "- $ctry..."
	sql="UPDATE ${sch}.view_full_occurrence_individual a SET is_in_country=b.is_in_country, is_in_state_province=b.is_in_state_province, is_in_county=b.is_in_county, is_geovalid=b.is_geovalid FROM ${sch}.pdg b WHERE a.country='${ctry}' AND a.is_geovalid_issue IS NULL AND a.is_geovalid IS NULL AND b.country='${ctry}' AND b.tbl_name='view_full_occurrence_individual' AND a.taxonobservation_id=b.tbl_id;"
	PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -c "$sql"
	source "$DIR/includes/check_status.sh"
done < countries

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi