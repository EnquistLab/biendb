#!/bin/bash

#########################################################################
# Purpose: Continues private BIEN analytical pipeline. Imports and updates
# 	TNRS results and exports input files for NSR and CSR (cultivated 
# 	species). Also generates endangered species tables, incorporating
#	TNRS results.
#
# Authors: Brad Boyle (bboyle@email.arizona.edu)
#########################################################################

: <<'COMMENT_BLOCK_x'
COMMENT_BLOCK_x
#echo "EXITING script `basename "$BASH_SOURCE"`"; exit 0

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
pname_master="$pname"
pname_header="$pname_header_prefix"" '""$pname""'"

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

: <<'COMMENT_BLOCK_1'

#############################################
# Import TNRS results & update database
#############################################
#echoi $e "-----------------------------------"
#source "$DIR/tnrs_batch/tnrs_batch_2_update.sh"

######################################
# Build taxonomy table 
######################################
echoi $e "-----------------------------------"
source "$DIR/bien_taxonomy/bien_taxonomy.sh"

######################################
# Remove non-plant taxa
#
# NOTE: Should be done earlier, but this is as early as I can put
# existing version as it requires TNRS results tables and completed
# bien_taxonomy. Would be a *lot* faster if done before TNRS, but will
# require a major rewrite of this script 
######################################
echoi $e "-----------------------------------"
source "$DIR/major_taxon/major_taxon.sh"

######################################################
# Extract file of taxon names and political divisions
# for scrubbing with NSR 
# Executing before endangered species and cultobs so
# can start NSR processing on different machine while
# endangered species and cultobs complete.
######################################################
echoi $e "-----------------------------------"
source "$DIR/nsr/nsr_1_prepare.sh"

######################################################
# Finish updating endangered species with TNRS results
######################################################
echoi $e "-----------------------------------"
source "$DIR/endangered_taxa/endangered_taxa_2_update.sh"

######################################################
# Populate & index spatial columns in all applicable
# tables
######################################################

COMMENT_BLOCK_1

######
# WARNING: check table parameters carefully before running!!!
######

echoi $e "-----------------------------------"
source "$DIR/populate_geom/populate_geom.sh"



######################################################
# Perform political division validation of geocoordinates
# 
# Spatial column geom must be present and indexed in 
# all tables prior to this step
######################################################

echoi $e "-----------------------------------"
source "$DIR/pdg/pdg_1_prepare.sh"	
source "$DIR/pdg/pdg_2_scrub.sh"	

source "$DIR/check_pks/check_pks.sh"

######################################################
# Check for cultivated observations
######################################################
echoi $e "-----------------------------------"
source "$DIR/cultobs/cultobs_1_prepare.sh"	# Prepare obs for scrubbing
source "$DIR/cultobs/cultobs_2_scrub.sh"	# Process obs with CULTOBS app
source "$DIR/cultobs/cultobs_3_update.sh"	# Update analytical tables

source "$DIR/check_pks/check_pks.sh"

######################################################
# Echo final instructions
######################################################

echoi $e "-----------------------------------"
msg_next_steps="$(cat <<-EOF

Script completed. Next step:

1. Scrub NSR input file using NSR and place results in NSR data directory

EOF
)"
echoi $e "$msg_next_steps"

######################################################
# Report total elapsed time and exit
######################################################

# Restore process name in case reset by sourced script
pname="$pname_master"
source "$DIR/includes/finish.sh"
