#!/bin/bash

#########################################################################
# Purpose: Remove TNRS name matching and resolution results from agg_traits
# and analytical_stem for names with match scores below the threshold 
# value (currently 0.53). 
#
# See README for details
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
	Data dir:	$data_dir
	Match threshold:	$match_threshold
	
EOF
	)"		
	confirm "$msg_conf"
fi

#########################################################################
# Main
#########################################################################

echoi $e "Executing module '$local_basename'"
echoi $e " "




### TEMP ####
echo "WARNING: portions of script `basename "$BASH_SOURCE"` commented out!"
# Other temporary code to be executed before comment block
# Start comment block
: <<'COMMENT_BLOCK_xxx'




mkdir -p $data_dir

echoi $e -n "Generating list of TNRS IDs of names below match threshold..."
sql="SELECT DISTINCT(fk_tnrs_id) FROM ${sch}.${vfoi} WHERE tnrs_name_matched_score<${match_threshold} AND fk_tnrs_id IS NOT NULL ORDER BY fk_tnrs_id"
#sql="SELECT species_nospace FROM ${sch}.${tbl} LIMIT 4"
# psql option '--no-align' avoids blank line at end of file
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 --no-align -q -t -c "${sql}" > "${data_dir}/TNRSIDs"
source "$DIR/includes/check_status.sh"

echoi $e "Purging names from table vfoi:"
echoi $e "  Deleting name results by ID:"
totids="$(wc -l < ${data_dir}/TNRSIDs)"
idno=0
while read currid; do
	let idno=idno+1
	echoi $e -r "    Name ${idno} of ${totids}..."
	PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch="$sch" -v vfoi="$vfoi" -v match_threshold=$match_threshold -v fk_tnrs_id=$currid -f $DIR_LOCAL/sql/purge_name_vfoi.sql
done < "${data_dir}/TNRSIDs"
echoi $e "   Name ${idno} of ${totids}...done"



# End comment block
COMMENT_BLOCK_xxx
# Temporary code to be executed after comment block
### TEMP ####





echoi $e "Purging names from table analytical_stem:"
echoi $e "  Deleting name results by ID:"
totids="$(wc -l < ${data_dir}/TNRSIDs)"
idno=0
while read currid; do
	let idno=idno+1
	echoi $e -r "    Name ${idno} of ${totids}..."
	PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch="$sch" -v match_threshold=$match_threshold -v fk_tnrs_id=$currid -f $DIR_LOCAL/sql/purge_name_astem.sql
done < "${data_dir}/TNRSIDs"
echoi $e "   Name ${idno} of ${totids}...done"

echoi $e "Purging names from table agg_traits:"
echoi $e "  Deleting name results by ID:"
totids="$(wc -l < ${data_dir}/TNRSIDs)"
idno=0
while read currid; do
	let idno=idno+1
	echoi $e -r "    Name ${idno} of ${totids}..."
	PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch="$sch" -v match_threshold=$match_threshold -v fk_tnrs_id=$currid -f $DIR_LOCAL/sql/purge_name_agg_traits.sql
done < "${data_dir}/TNRSIDs"
echoi $e "   Name ${idno} of ${totids}...done"


#rm "${data_dir}/TNRSIDs"

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi