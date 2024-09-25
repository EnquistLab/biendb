#!/bin/bash

#########################################################################
# Purpose: Custom top-level db pipeline script for updating data dictionary
#	tables as separate operation. NOT part of DB pipeline.
#
# NOTE: You must manually edit the spreadsheet created by step 1 
#	(data_dictionary_1_create.sh) to make changes to table, column 
#	or value definitions.
# 
# Author: Brad Boyle (bboyle@email.arizona.edu)
#########################################################################

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
EOF
)"		
source "$DIR/includes/confirm.sh"
	
#########################################################################
# Main
#########################################################################

# Copy over political division tables from gnrs database
#source "$DIR/poldiv_tables/poldiv_tables.sh"

######################################################
# Create data dictionary based on "cleaned" schema
######################################################

echoi $e "-----------------------------------"
source "$DIR/data_dictionary/data_dictionary_1_create.sh"	

######################################
# Update data dictionary
######################################

echoi $e "-----------------------------------"
source "$DIR/data_dictionary/data_dictionary_2_update.sh"	


######################################################
# Report total elapsed time and exit
######################################################

# Restore process name in case reset by sourced script
pname=$pname_master
source "$DIR/includes/finish.sh"
