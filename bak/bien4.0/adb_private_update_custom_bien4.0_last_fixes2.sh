#!/bin/bash

#########################################################################
# Purpose: REALLY last fixes to BIEN 4.0 private database
#
# Details: This one removes traits with <300 species and updates affected
#	metadata tables.
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

# Set process name for emails and echo
pname=$master
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
	
db=$db_public; sch=$prod_schema_adb_public

######################################################
# Custom confirmation message. 
# Will only be displayed if running as
# standalone script and -s (silent) option not used.
######################################################

startup_msg_opts="$(cat <<-EOF
	Database:		$db
	Schema:			$sch
EOF
)"		
source "$DIR/includes/confirm.sh"

#########################################################################
# Main
#########################################################################

######################################################
# Apply traits species embargo
######################################################

echoi $e "-----------------------------------"
echoi $e "Apply traits species embargo:"
echoi $e " "

source "$DIR/adb_public_embargoes/adb_public_embargoes_trait_sp_count_only.sh"

######################################################
# Rebuild metadata tables 
######################################################
echoi $e "-----------------------------------"
echoi $e "Rebuilding affected metadata tables:"
echoi $e " "

# Set parameters for next two steps
db=$db_public; dev_schema=$prod_schema_adb_public
tbl_vfoi="view_full_occurrence_individual"

# Rebuild affected metadata tables
source "$DIR/trait_metadata/trait_metadata.sh"
source "$DIR/bien_species_all/bien_species_all.sh"

######################################################
# Populate count fields in the newly-inserted record.
######################################################

echoi $e "-----------------------------------"
echoi $e "Updating bien_summary:"
echoi $e " "

dev_schema=$prod_schema_adb_public

echoi $e -n "- Counting observations..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_public --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR/bien_summary_public/sql/count_obs.sql
source "$DIR/includes/check_status.sh"

echoi $e -n "- Counting geovalid observations..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_public --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR/bien_summary_public/sql/count_obs_geovalid.sql
source "$DIR/includes/check_status.sh"

echoi $e -n "- Counting species..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_public --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR/bien_summary_public/sql/count_species.sql
source "$DIR/includes/check_status.sh"

######################################################
# Report total elapsed time and exit
######################################################

# Restore process name in case reset by sourced script
pname=$pname_master
source "$DIR/includes/finish.sh"
