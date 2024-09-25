#!/bin/bash

#########################################################################
# Purpose: Custom add-on to step 3, forgot to run module major_taxon!
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

db=$db_private; sch=$dev_schema_adb_private

#########################################################################
# Main
#########################################################################

######################################################
# Remove all indexes from main tables
######################################################
#echoi $e "-----------------------------------"
#source "$DIR/restore_indexes/drop_indexes_dev.sh"
#currscript=`basename "$0"`; echo "EXITING script $currscript"; exit 0

######################################################
# Remove non-plant names and correct higher_plant_group
######################################################
# Commenting out the first step to resume at second step after crash
#echoi $e "-----------------------------------"
#source "$DIR/major_taxon/major_taxon.sh"

######################################################
# Index completed tables
#
# Use '_dev' version of script as vfoi and 
# analyticaL_stem still have '_dev' suffixes at 
# this stage
######################################################
echoi $e "-----------------------------------"
# Critically important to set these parameters!
db=$db_private; sch=$dev_schema_adb_private
#source "$DIR/restore_indexes/restore_indexes_dev.sh"

# Resume from crash here:
source "$DIR/restore_indexes/restore_indexes_dev_temp_resume.sh"

######################################################
# Make final metadata tables and tidy up
######################################################
echoi $e "-----------------------------------"
echoi $e "Making final metadata tables:"
echoi $e " "

# set parameters for next step
db=$db_private; dev_schema=$dev_schema_adb_private
source "$DIR/trait_metadata/trait_metadata.sh"

source "$DIR/data_contributors/data_contributors.sh"

source "$DIR/species_by_political_division/species_by_political_division.sh"

db=$db_private; dev_schema=$dev_schema_adb_private
tbl_vfoi="view_full_occurrence_individual_dev"
source "$DIR/bien_species_all/bien_species_all.sh"

source "$DIR/bien_metadata/bien_metadata.sh"

db=$db_private; dev_schema=$dev_schema_adb_private
source "$DIR/bien_summary/bien_summary.sh"

# Import spreadsheet to table data_dictionary_rbien
source "$DIR/data_dictionary_rbien/data_dictionary_rbien.sh"

# Create tables species and observations_union
source "$DIR/observations_union/observations_union.sh"

######################################################
# Clean up
######################################################
echoi $e "-----------------------------------"
source "$DIR/cleanup/cleanup.sh"
#echoi $e "Skipping cleanup! Do manually"
echoi $e " "

######################################################
# Create data dictionary based on "cleaned" schema
######################################################

echoi $e "-----------------------------------"
source "$DIR/data_dictionary/data_dictionary_1_create.sh"	

######################################################
# Echo final instructions
######################################################

msg_next_steps="$(cat <<-EOF

Script completed. Next steps:

1. Manually delete any unneeded tables or sequences
2. Rebuild data dictionary
3. Update data dictionary

EOF
)"
echoi $e "$msg_next_steps"


######################################################
# Report total elapsed time and exit
######################################################

# Restore process name in case reset by sourced script
pname=$pname_master
source "$DIR/includes/finish.sh"
