#!/bin/bash

#########################################################################
# Purpose: Final updates to BIEN analytical database. 
#
# Details: Imports manual updates to data_dictionary and table datasource
# 
# Authors: Brad Boyle (bboyle@email.arizona.edu)
#########################################################################

# Comment-block tags - Use for all temporary comment blocks

#### TEMP ####
# echo "WARNING: portions of script `basename "$BASH_SOURCE"` commented out!"
## Start comment block
# : <<'COMMENT_BLOCK_xxx'

## End comment block
# COMMENT_BLOCK_xxx
#### TEMP ####

## Exit all scripts
# echo "EXITING script `basename "$BASH_SOURCE"`"; exit 0

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

if [[ $appendlog == "true" ]]; then
	replacelog="false"
else
	replacelog="true"
fi

startup_msg_opts="$(cat <<-EOF
	Database:		$db_main
	Schema:			$sch_main
	Load phylogenies:	$load_phylo
	DB build type:		$db_build
	Logfile:		$glogfile
	Replace logfile:	$replacelog
EOF
)"		
source "$DIR/includes/confirm.sh"
	
#########################################################################
# Main
#########################################################################

######################################
# Update data dictionary
######################################

echoi $e "-----------------------------------"
source "$DIR/data_dictionary/data_dictionary_2_update.sh"	

######################################
# Update datasource table
######################################

echoi $e "-----------------------------------"
source "$DIR/datasource/datasource_3_update.sh"	

######################################################
# Echo final instructions
######################################################

msg_next_steps="$(cat <<-EOF

Script completed. Next step:

1. Set permissions to allow access by bien_private, etc. (see module users/)
2. Inspect & validate private $dev_schema
3. Run VACUUM ANALYZE on entire schema!
4. Run adb_public.sh to generate public version  
	of analytical database
5. Archive current schemas and make development current

EOF
)"
echoi $e "$msg_next_steps"

######################################################
# Report total elapsed time and exit
######################################################

# Restore process name in case reset by sourced script
pname=$pname_master
source "$DIR/includes/finish.sh"
