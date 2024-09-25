#!/bin/bash

#########################################################################
# Purpose: Assigns or revokes user to/from roles
#
# Notes:
#	All parameters specified in local params file, not main params. 
#	Not part of db pipeline.
#
# Authors: Brad Boyle (bboyle@email.arizona.edu)
#########################################################################

: <<'COMMENT_BLOCK_x'
COMMENT_BLOCK_x
#currscript=`basename "$0"`; echo "EXITING script $currscript"; exit 0

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
# Echo confirmation message
###########################
if [[ "$i" = "true" ]]; then 
	# Reset confirmation message
	msg_conf="$(cat <<-EOF

	Process '$pname' will use following parameters: 
	
	User --> role (action)
	-----------------------
EOF
	)"	

for user_role in $user_roles; do
	user_role2=${user_role//,/ }
	user_role_arr=($user_role2)
	
	user_role_disp=${user_role_arr[0]}" --> "${user_role_arr[1]}" ("${user_role_arr[2]}")"

	msg_conf="$(cat <<-EOF
	$msg_conf
	$user_role_disp
EOF
	)"

done
		
	confirm "$msg_conf"
fi
	
#########################################################################
# Main
#########################################################################

echoi $e "Executing module '$local_basename'"

echoi $e "- Assigning/revoking roles:"
if [[ "$user_roles" == "" ]]; then
	echoi $e "-- [No user roles specified]"
else
	for user_role in $user_roles; do
		user_role2=${user_role//,/ }
		user_role_arr=($user_role2)
		usr=${user_role_arr[0]}
		rol=${user_role_arr[1]}
		act=${user_role_arr[2]}
		
		echoi $e -n "-- $usr --> $rol ($act)..."
		
		if [[ "$act" == "assign" ]]; then
		
			sudo -u postgres PGOPTIONS='--client-min-messages=warning' psql --set ON_ERROR_STOP=1 -q -v usr=$usr -v rol=$rol -f $DIR_LOCAL/sql/assign_role.sql
		elif [[ "$act" == "revoke" ]]; then
			sudo -u postgres PGOPTIONS='--client-min-messages=warning' psql --set ON_ERROR_STOP=1 -q -v usr=$usr -v rol=$rol -f $DIR_LOCAL/sql/revoke_role.sql
		else
			echo "ERROR! '$rol: No such role!"; exit 1
		fi
		source "$DIR/includes/check_status.sh"
	done
fi

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi


