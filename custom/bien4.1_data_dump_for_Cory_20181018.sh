#!/bin/bash

#########################################################################
# Purpose: Dump of vfoi for range modeling
#  
# Author: Brad Boyle (bboyle@email.arizona.edu)
#########################################################################

: <<'COMMENT_BLOCK_x'
COMMENT_BLOCK_x
#echoi $e; echoi $e "EXITING script `basename "$BASH_SOURCE"`"; exit 0

######################################################
# Load external parameters & functions & confirm operation
# 
# IF called by master script in parent directory, loads 
# local parameters only. If running standalone, loads
# all parameters (global and local) plus functions and 
# options. You may also set custom parameters, if any,
# in next section
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
# Custom parameters
#  
# In case of name collisions, will over-ride parameters
# from local (params.sh) and global (../params.sh)
# parameters files
######################################################

# Db & schema
db="vegbien"
#sch="analytical_db_dev"
sch="analytical_db"

# Target directory where files will be written
data_dir="/home/boyle/bien3/data_requests/cmerow"

# File names and paths
#obsfile_name="bien4.1_dump_20181018.txt"
#lookupfile_name="bien4.1_dump_20181018_species_lookup.txt"
obsfile_name="bien4.0.3_dump_20181018.txt"
lookupfile_name="bien4.0.3_dump_20181018_species_lookup.txt"

obsfile=$data_dir"/"$obsfile_name
lookupfile=$data_dir"/"$lookupfile_name

######################################################
# Custom confirmation message. 
# Will only be displayed if running as
# standalone script and -s (silent) option not used.
######################################################

if [[ "$i" = "true" && -z ${master+x} ]]; then 

	# Reset confirmation message
	msg_conf="$(cat <<-EOF

	Process '$pname_local' will use following parameters: 
	
	Database:		$db
	Schema:			$sch
	Data directory:		$data_dir
	Observations file:	$obsfile_name
	Lookup file:		$lookupfile_name

EOF
	)"		
	confirm "$msg_conf"
fi
echoi $e ""

#########################################################################
# Main
#########################################################################

echoi $e "Executing module '$local_basename'"; echoi $e ""

######################################################
# Make observations file
######################################################

echoi $e "Observations file:"

# Note write to STDOUT to avoid having to run as sudo
echoi $e -n "- Exporting file..."
sql="COPY (SELECT taxonobservation_id, scrubbed_family, scrubbed_species_binomial, latitude, longitude FROM ${sch}.view_full_occurrence_individual WHERE scrubbed_species_binomial IS NOT NULL AND is_geovalid = 1 AND (georef_protocol is NULL OR georef_protocol<>'county centroid') AND higher_plant_group NOT IN ('Algae','Bacteria','Fungi') AND (is_introduced=0 OR is_introduced IS NULL) AND (is_cultivated_observation = 0 OR is_cultivated_observation IS NULL) AND is_location_cultivated IS NULL AND (is_centroid IS NULL OR is_centroid=0)
AND observation_type IN ('plot','specimen','literature','checklist') ORDER BY scrubbed_family, scrubbed_species_binomial ) TO STDOUT WITH ( FORMAT csv, DELIMITER E'\t', HEADER )" 

PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db --set ON_ERROR_STOP=1 -q -c "$sql" > $obsfile
source "$DIR/includes/check_status.sh"

echoi $e -n "- Compressing file to archive..."
zip -jq $obsfile".zip" $obsfile 
source "$DIR/includes/check_status.sh"

echoi $e -n "- Deleteing uncompressed file..."
#rm $obsfile
source "$DIR/includes/check_status.sh"

######################################################
# Make lookup file
######################################################

echoi $e "Family-species lookup file:"

# Note write to STDOUT to avoid having to run as sudo
echoi $e -n "- Exporting lookup file of species..."
sql="COPY (SELECT DISTINCT scrubbed_family, scrubbed_species_binomial FROM ${sch}.view_full_occurrence_individual WHERE scrubbed_species_binomial IS NOT NULL AND is_geovalid = 1 AND (georef_protocol is NULL OR georef_protocol<>'county centroid') AND higher_plant_group NOT IN ('Algae','Bacteria','Fungi') AND (is_introduced=0 OR is_introduced IS NULL) AND (is_cultivated_observation = 0 OR is_cultivated_observation IS NULL) AND is_location_cultivated IS NULL AND (is_centroid IS NULL OR is_centroid=0)
AND observation_type IN ('plot','specimen','literature','checklist') ORDER BY scrubbed_family, scrubbed_species_binomial ) TO STDOUT WITH ( FORMAT csv, DELIMITER E'\t', HEADER )" 

PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db --set ON_ERROR_STOP=1 -q -c "$sql" > $lookupfile
source "$DIR/includes/check_status.sh"

echoi $e -n "- Compressing file to archive..."
zip -jq $lookupfile".zip" $lookupfile 
source "$DIR/includes/check_status.sh"

echoi $e -n "- Deleteing uncompressed file..."
#rm $lookupfile
source "$DIR/includes/check_status.sh"
######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi