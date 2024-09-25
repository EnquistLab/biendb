#!/bin/bash

#########################################################################
# Purpose: Grants select permissions on schema $sch in db $db for list of
#	users $users_select. Grants all privileges on schema $sch in db $db 
# 	for list of users $users_full. All parameters specified in local 
# 	params file, not main params. Not part of db pipeline.
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

######################################################
# Custom confirmation message, showing parameters
# to be used. Will only be displayed if running as
# standalone script and -s (silent) option not used.
######################################################

###########################
# prepare lists of users
###########################
users_select_all=""
if [[ "$users_select" == "" ]]; then
	users_select_all="[No users specified]"
else
	for usr in $users_select; do
		users_select_all=$users_select_all", "$usr
	done
	users_select_all="${users_select_all/', '/''}"
fi

users_full_all=""
if [[ "$users_full" == "" ]]; then
	users_full_all="[No users specified]"
else
	for usr in $users_full; do
		users_full_all=$users_full_all", "$usr
	done
	users_full_all="${users_full_all/', '/''}"
fi

users_revoke_all=""
if [[ "$users_revoke" == "" ]]; then
	users_revoke_all="[No users specified]"
else
	for usr in $users_revoke; do
		users_revoke_all=$users_revoke_all", "$usr
	done
	users_revoke_all="${users_revoke_all/', '/''}"
fi

###########################
# Echo the message
###########################
if [[ "$i" = "true" && -z ${master+x} ]]; then 
	# Reset confirmation message
	msg_conf="$(cat <<-EOF

	Process '$pname' will use following parameters: 
	
	Database:	$db
	Schema:		$sch
	Select privileges to: 	$users_select_all
	Full privileges to: 	$users_full_all
	Revoke privileges from: $users_revoke_all
EOF
	)"		
	confirm "$msg_conf"
fi
	
#########################################################################
# Main
#########################################################################

echoi $e "Executing module '$local_basename'"

: <<'COMMENT_BLOCK_1'
# Not sure I understand the following. Check and correct or delete
echoi $e -n "- Revoking all db connect privileges..."
sudo -u postgres PGOPTIONS='--client-min-messages=warning' psql -d $db --set ON_ERROR_STOP=1 -q -v db=$db -f $DIR_LOCAL/sql/db_revoke_connect.sql
source "$DIR/includes/check_status.sh"

COMMENT_BLOCK_1


echoi $e "- Granting select permission for users on schema '$sch':"
if [[ "$users_select" == "" ]]; then
	echoi $e "-- [No users specified]"
else
	for usr in $users_select; do
		echoi $e -n "-- $usr..."
		sudo -u postgres PGOPTIONS='--client-min-messages=warning' psql -d $db --set ON_ERROR_STOP=1 -q -v db=$db -v sch=$sch -v usr=$usr -f $DIR_LOCAL/sql/schema_grant_select_default.sql
		source "$DIR/includes/check_status.sh"
	done
fi

echoi $e "- Granting full permissions for user on schema '$sch':"
if [[ "$users_full" == "" ]]; then
	echoi $e "-- [No users specified]"
else
	for usr in $users_full; do
		echoi $e -n "-- $usr..."
		sudo -u postgres PGOPTIONS='--client-min-messages=warning' psql -d $db --set ON_ERROR_STOP=1 -q -v db=$db -v sch=$sch -v usr=$usr -f $DIR_LOCAL/sql/schema_grant_all.sql
		source "$DIR/includes/check_status.sh"
	done
fi

echoi $e "- Revoking permissions for users on schema '$sch':"
if [[ "$users_revoke" == "" ]]; then
	echoi $e "-- [No users specified]"
else
	for usr in $users_revoke; do
		echoi $e -n "-- $usr..."
		sudo -u postgres PGOPTIONS='--client-min-messages=warning' psql -d $db --set ON_ERROR_STOP=1 -q -v db=$db -v sch=$sch -v usr=$usr -f $DIR_LOCAL/sql/schema_revoke_all.sql
		source "$DIR/includes/check_status.sh"
	done
fi

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi


