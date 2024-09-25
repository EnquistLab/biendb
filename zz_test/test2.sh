#!/bin/bash

: <<'COMMENT_BLOCK_x'
COMMENT_BLOCK_x
#echo; echo "EXITING script `basename "$BASH_SOURCE"`"; exit 0

######################################################
# Set parameters, load functions & confirm operation
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

	Process process '$pname' using the following parameters?
	
	Database:				$db
	Schema:					$sch
	
EOF
	)"		
	confirm "$msg_conf"
fi

#########################################################################
# Main
#########################################################################

echoi $e "Executing module '$local_basename'"


echo ""
echo "- test: WARNING1: portions of script `basename "$0"` commented out!"
echo "- test: WARNING2: portions of script `basename "$BASH_SOURCE"` commented out!"
echo "- EXITING script `basename "$BASH_SOURCE"`"; exit 0




######################################################
# Extract political divisions and export for scrubbing
######################################################


echoi $e -n "-  Querying \"owned_by_postgres\" as user \"$user\"..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db -v ON_ERROR_STOP=OFF -q -c "SELECT * FROM ${sch}.owned_by_postgres" > /dev/null >> $tmplog
#source "$DIR/includes/check_status.sh"	
echo "done"

echoi $e -n "- Querying \"owned_by_postgres\" as user \"postgres\"..."
sudo -u postgres PGOPTIONS='--client-min-messages=warning' psql -d $db -q -c "SELECT * FROM ${sch}.owned_by_postgres" > /dev/null >> $tmplog
#PGOPTIONS='--client-min-messages=warning' psql -U postgres -d $db -q -c "SELECT * FROM ${sch}.owned_by_postgres" > /dev/null >> $tmplog
echo "done"


echoi $e -n "-  Querying \"owned_by_bien\" as user \"$user\"..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db -v ON_ERROR_STOP=OFF -q -c "SELECT * FROM ${sch}.owned_by_bien" > /dev/null >> $tmplog
echo "done"

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi