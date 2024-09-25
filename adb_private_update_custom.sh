#!/bin/bash

#########################################################################
# Purpose: Custom top-level db pipeline script for executing individual
#	pipeline steps as needed. Paste in steps below. Use at your own risk!
# 
# Author: Brad Boyle (bboyle@email.arizona.edu)
#########################################################################

: <<'COMMENT_BLOCK_x'
COMMENT_BLOCK_x
#currscript=`basename "$0"`; echo "EXITING script $currscript"; exit 0

######################################################
# Set basic parameters, functions and options
######################################################

# Enable the following for strict debugging only:
#set -e

# The name of this file. Tells sourced scripts not to reload general  
# parameters and command line options as they are being called by  
# another script. Allows component scripts to be called individually  
# if needed
master=`basename "$0"`

# Get working directory
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

# Load parameters, functions and get command-line options
source "$DIR/includes/startup_master.sh"

######################################################
# Custom confirmation message. 
# Will only be displayed if running as
# standalone script and -s (silent) option not used.
######################################################

# Set process name for emails and echo
pname=$pname_1
pname_master=$pname
pname_header=$pname_header_prefix" '"$pname"'"

# Set default targets for confirmation message
db_main=$db_private
sch_main=$dev_schema_adb_private
if [[ $use_limit == "true" ]]; then
	db_build="sample"
else
	db_build="full"
fi

startup_msg_opts="$(cat <<-EOF
	Database:		$db_main
	Schema:			$sch_main
	Load phylogenies:	$load_phylo
	DB build type:		$db_build
EOF
)"		
source "$DIR/includes/confirm.sh"
	
#########################################################################
# Main
#########################################################################

echoi $e "-----------------------------------"
#source "$DIR/set_permissions/set_permissions.sh"

db="vegbien"
sch="analytical_db_dev2"
tbl="country"

echoi $e -n "- Checking database '$db'..."
if ! psql -lqt | cut -d \| -f 1 | grep -qw $db; then
	echo "ERROR: Database missing!"
else
	echo "done"
fi

echoi $e -n "- Checking schema '$sch' in db '$db'..."
sch_exists=$(exists_schema_psql -u $user -d $db -s $sch)
if [[ $sch_exists == "f" ]]; then
	echo "ERROR: Schema '$sch' doesn't exist in db '$db'!"
else
	echo "done"
fi

echoi $e -n "- Checking table '$tbl' in schema '$sch' of db '$db'..."
tbl_exists=$(exists_table_psql -d $db -u $user -s $sch -t $tbl )
if [[ $tbl_exists == "f" ]]; then
	echo "ERROR: Table missing!"
else
	echo "done"
fi

######################################################
# Echo final instructions
######################################################

msg_next_steps="$(cat <<-EOF

Next steps: Nada!

EOF
)"
echoi $e "$msg_next_steps"


######################################################
# Report total elapsed time and exit
######################################################

# Restore process name in case reset by sourced script
pname=$pname_master
source "$DIR/includes/finish.sh"
