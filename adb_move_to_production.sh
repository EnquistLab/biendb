#!/bin/bash

#########################################################################
# Purpose: Moves completed & validated private & public analytical  
#	databases to production. In each case, deletes entire schema  
# 	containing production database and renames development schema to  
#	productions schema. Backs up both before starting.
#  
# WARNINGS: 
#	1. Will delete existing production schemas!
#	2. Existing development schemas will be renamed to production
#		schemas and will no longer exist
#  
# Requirements:
#	1. Completed development private analytical database must exist  
# 		as schema "analytical_db_dev" in database "vegbien"
#	2. Completed development public analytical database must exist  
# 		as schema "analytical_db_dev" in database "public_vegbien"
# 
# Authors: Brad Boyle (bboyle@email.arizona.edu)
# Date created: 21 April 2017
#########################################################################

: <<'COMMENT_BLOCK_x'
COMMENT_BLOCK_x

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

# Confirm operation
source "$DIR/includes/confirm.sh"
	
#########################################################################
# Main
#########################################################################

######################################################
# Backup both public and private production DBs (=schemas)
######################################################

source "$DIR/backup/backup_adb_private.sh"
source "$DIR/backup/backup_adb_public.sh"

######################################################
# Rename current production schemas to backup names,
# and new (development) schemas to production names
######################################################

source "$DIR/move_to_production/move_to_production.sh"

######################################################
# Echo final instructions
######################################################

msg_next_steps="$(cat <<-EOF

Script completed. Remaining steps:

1. Delete manually the backup copy schemas
of the old production schemas after the new schemas have 
been validated.
2. Check all permissions
3. Manually update biendata.org

EOF
)"
echoi $e "$msg_next_steps"

######################################################
# Report total elapsed time and exit
######################################################

source "$DIR/includes/finish.sh"
