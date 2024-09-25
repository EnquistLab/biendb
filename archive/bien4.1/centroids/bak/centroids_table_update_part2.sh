#!/bin/bash

#########################################################################
# Purpose: One-time hack to import Brian M's update of centroid columns
# 	for transfer to vfoi and agg_traits
#
# Authors: Brad Boyle (bboyle@email.arizona.edu)
#########################################################################

: <<'COMMENT_BLOCK_x'
COMMENT_BLOCK_x

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

# Construct LIMIT clause if applicable (for testing only)
# determines if global $use_limit and $record_limit will be applied
# Sets final values of $use_limit_local and $sql_limit_local
sql_limit_local=""
if [ $use_limit == "true" ]; then
	if [ $use_limit_local == "false" ] && [ $force_limit != "true" ]; then
		sql_limit_local=""
	else
		sql_limit_local=$sql_limit_global
	fi
fi

if [ $use_limit_local == "true" ]; then
	if  [ $use_limit == "false" ] && [ $force_limit == "true" ]; then
		# Force reset of local limit
		use_limit_local="false"
		sql_limit_local=""
	else
		sql_limit_local=$sql_limit_global
	fi
fi

######################################################
# Custom confirmation message. 
# Will only be displayed if running as
# standalone script and -s (silent) option not used.
######################################################

if [[ "$i" = "true" && -z ${master+x} ]]; then 

	# Record limit display
	if [[ "$use_limit_local" == "false" ]]; then
		limit_disp="false"
	else 
		limit_disp="true (limit="$recordlimit")"
	fi

	# Reset confirmation message
	msg_conf="$(cat <<-EOF

	Process '$pname' will use following parameters: 
	
	Database:			$db_private
	Schema:				$dev_schema
	Use record limit:		$limit_disp
	
EOF
	)"		
	confirm "$msg_conf"
fi

#########################################################################
# Main
#########################################################################

echoi $e "Executing module '$local_basename'"

#########################################################################
# Import centroid validation results 
#########################################################################

echoi $e -n "- Creating second centroid results table..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/create_tables_centroid_update.sql
source "$DIR/includes/check_status.sh"	

echoi $i -n "- Importing centroid update file to table centroid_2..."
if [[ "$use_limit_local" == "true" ]]; then 	
	echoi $i -n "[using recordlimit=$recordlimit]..."
	# Import subset of records (for development only)
	head -n $recordlimit $data_dir_local/$centroid_2_filename | psql $db_private $user -q -c "COPY ${dev_schema}.centroid_2 FROM STDIN WITH CSV DELIMITER ',' HEADER QUOTE E'\"' NULL 'NA'"
else
	# Import full file
	sql="\copy centroid_2 FROM '${data_dir_local}/${centroid_2_filename}' CSV DELIMITER ',' HEADER QUOTE E'\"' NULL 'NA';"
	PGOPTIONS='--client-min-messages=warning' psql $db_private $user -q << EOF
	\set ON_ERROR_STOP on
	SET search_path TO $dev_schema;
	$sql
EOF
fi
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Merging results to table centroid..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/merge_centroid_results.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Indexing centroid table..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/index_centroid.sql
source "$DIR/includes/check_status.sh"	

echoi $e "- Updating centroid columns in tables:"

echoi $e "-- SKIPPING THIS STEP!"

: <<'COMMENT_BLOCK_1'

echoi $e -n "- view_full_occurrence_individual..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/centroid_update_vfoi.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "- agg_traits..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR_LOCAL/sql/centroid_update_agg_traits.sql
source "$DIR/includes/check_status.sh"	

COMMENT_BLOCK_1

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi

######################################################
# End script
######################################################