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

######################################################
# Extract political divisions and export for scrubbing
######################################################

echoi $e -n "- Querying \"owned_by_bien\" as user \"$user\"..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d  $db_private -v ON_ERROR_STOP=OFF -q -c "SELECT * FROM ${sch}.owned_by_bien" > /dev/null >> $tmplog
echo "done"

: <<'COMMENT_BLOCK_1'

echoi $i -n "- Creating table \"owned_by_bien2\" as user \"$user\"..."
PGOPTIONS='--client-min-messages=warning' psql $db_private $user -q << EOF
\set ON_ERROR_STOP off
SET search_path TO $sch;
DROP TABLE IF EXISTS owned_by_bien2;
CREATE TABLE owned_by_bien2 (id serial not null);
EOF
echo "done"

echoi $i -n "- Creating table \"owned_by_postgres2\" as user \"postgres\"..."
sudo -u postgres PGOPTIONS='--client-min-messages=warning' psql -d $db_private -q << EOF
\set ON_ERROR_STOP off
SET search_path TO $sch;
DROP TABLE IF EXISTS owned_by_postgres2;
CREATE TABLE owned_by_postgres2 (id serial not null);
EOF
echo "done"

echoi $i -n "- Dropping table \"owned_by_postgres2\" as user \"$user\"..."
PGOPTIONS='--client-min-messages=warning' psql -d $db_private -U $user -q << EOF
\set ON_ERROR_STOP off
SET search_path TO $sch;
DROP TABLE IF EXISTS owned_by_postgres2;
EOF
echo "done"


echoi $i -n "- Dropping tables \"owned_by_bien2\" & \"owned_by_postgres2\" as user \"postgres\"..."
sudo -u postgres PGOPTIONS='--client-min-messages=warning' psql -d $db_private -q << EOF
\set ON_ERROR_STOP off
SET search_path TO $sch;
DROP TABLE IF EXISTS owned_by_postgres2;
DROP TABLE IF EXISTS owned_by_bien2;
EOF
echo "done"

COMMENT_BLOCK_1

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi