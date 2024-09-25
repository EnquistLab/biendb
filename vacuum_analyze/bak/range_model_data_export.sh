#!/bin/bash

#########################################################################
# Purpose: Export BIEN range model metadata, and raw data by species
#
# Requires tables generatedd by query_species.sh & range_model_data.sh:
#	species_observation_counts_crosstab
#	species_observation_counts_filters
#	range_model_data_metadata
#	range_model_data_raw
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
# Local parameters
######################################################

base_dir="/home/boyle/bien/data_requests"
data_dir="${base_dir}/bien4.2/range_model_data"

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
	Export dir:	$data_dir
	
EOF
	)"		
	confirm "$msg_conf"
fi

#########################################################################
# Main
#########################################################################

echoi $e "Executing module '$local_basename'"
echoi $e " "

# Dump the crosstab, crosstab filter and metadata files
tbls="
species_observation_counts_crosstab
species_observation_counts_filters
range_model_data_metadata
"
echoi $e "Exporting metadata tables:"
for tbl in $tbls; do
	outfile="${tbl}.csv"
	echoi $e -n "  ${tbl}-->${outfile}..."
	metacmd="\copy ${sch}.${tbl} to '${data_dir}/${outfile}' delimiter ',' csv header"
	PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -c "${metacmd}"
	source "$DIR/includes/check_status.sh"
done

echoi $e -n "Generating species list..."
tbl="range_model_data_raw"
sql="SELECT DISTINCT(species_nospace) FROM ${sch}.range_model_data_raw ORDER BY species_nospace"
#sql="SELECT species_nospace FROM ${sch}.${tbl} LIMIT 4"
# psql option '--no-align' avoids blank line at end of file
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 --no-align -q -t -c "${sql}" > "${data_dir}/SPECIES"
source "$DIR/includes/check_status.sh"

nspp="$(wc -l < ${data_dir}/SPECIES)"
sp=0
spp_data_dir="${data_dir}/species"
mkdir -p $spp_data_dir

echoi $e "Exporting raw data by species:"
while read currsp; do
	let sp=sp+1
	echoi $e -r "  Species ${sp} of ${nspp}..."
	outfile="${currsp}.csv"
	metacmd="\copy (SELECT taxonobservation_id, scrubbed_species_binomial, species_nospace, latitude, longitude FROM ${sch}.${tbl} WHERE species_nospace='${currsp}') to '${spp_data_dir}/${outfile}' delimiter ',' csv header"
	PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -c "${metacmd}"
done < "${data_dir}/SPECIES"
echoi $e " Species ${sp} of ${nspp}...done"

rm "${data_dir}/SPECIES"

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi