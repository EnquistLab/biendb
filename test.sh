#!/bin/bash

######################################################
# Scripts for testing features of pipeline
# See also child processes in directory test
# DON'T DELETE!
######################################################

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

# Set process name for emails and echo
pname_header=$pname_header_prefix" '"$pname"'"

# Set key parameters here to over-ride any settings above
db=$db_private
sch="analytical_db_dev2"


#########################################################################
# Echo key settings and confirm operation
#########################################################################

if [[ "$i" = "true" ]]; then 
	# Reset confirmation message
	msg_conf="$(cat <<-EOF

	Run test script using following parameters:
	
	Database:				$db
	Schema:					$sch

EOF
	)"		
	confirm "$msg_conf"
fi

# Send notification mails if requested, but suppress main message
suppress_main="true"
source "$DIR/includes/confirm.sh"
	
#########################################################################
# Main
#########################################################################

: <<'COMMENT_BLOCK_1'
COMMENT_BLOCK_1

# first script
source "$DIR/test/test2.sh"

# second script
source "$DIR/test/test3.sh"


######################################################
# Report total elapsed time and exit
######################################################

source "$DIR/includes/finish.sh"
