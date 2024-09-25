#!/bin/bash

#########################################################################
# Purpose: Step 2 of BIEN database pipeline. 
#
# Details: Import results of TNRS, GNRS and CDS validations. Perform
#	additional standardizations. Export CSV files for validation
#	by CODS and NSR.
#
# Authors: Brad Boyle (bboyle@email.arizona.edu)
#########################################################################

# Comment-block tags - Use for all temporary comment blocks

#### TEMP ####
# echo "WARNING: portions of script `basename "$BASH_SOURCE"` commented out!"
## Other temporary code to be executed before comment block
## Start comment block
# : <<'COMMENT_BLOCK_xxx'

## End comment block
# COMMENT_BLOCK_xxx
## Temporary code to be executed after comment block
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
export master=`basename "$0"`

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

# Source list display
sources_disp=""
if [[ "$sources" == "" ]]; then
	sources_disp="[No sources specified]"
else
	for src in $sources; do
		sources_disp=$sources_disp", "$src
	done
	sources_disp="${sources_disp/', '/''}"
fi

# Record limit display
if [[ "$use_limit" == "true" ]]; then
	limit_disp="true (limit="$recordlimit")"
else
	limit_disp="false"
fi

if [[ "$appendlog" == "true" ]]; then
	replacelog="false"
else
	replacelog="true"
fi

startup_msg_opts="$(cat <<-EOF
	Database:		$db_main
	Schema:			$sch_main
	Sources:		$sources_disp
	Load phylogenies:	$load_phylo
	Use record limit?:	$limit_disp
	Logfile:		$glogfile
	Replace logfile:	$replacelog
EOF
)"		
source "$DIR/includes/confirm.sh"	

echoi $e "Start: $(date)"
echoi $e " "

#########################################################################
# Main
#########################################################################

# Start by confirming unique primary keys
source "$DIR/checks/check_pks.sh"

######################################################
# Import results of TNRS, build taxonomy table and
# update all TNRS columns in vfoi
######################################################
echoi $e "-----------------------------------"
echoi $e "Importing results of TNRS validations:"
source "$DIR/tnrs/tnrs_3_update.sh"
source "$DIR/checks/check_pks.sh"

source "$DIR/bien_taxonomy/bien_taxonomy.sh"
source "$DIR/checks/check_pks.sh"

######################################
# Remove non-plant taxa
######################################
echoi $e "-----------------------------------"
source "$DIR/major_taxon/major_taxon.sh"

######################################################
# Finish updating endangered species with TNRS results
######################################################
echoi $e "-----------------------------------"
source "$DIR/endangered_taxa/endangered_taxa_2_update.sh"

######################################################
# Import results of GNRS validations
######################################################

echoi $e "-----------------------------------"
echoi $e "Importing results of GNRS validations:"
source "$DIR/gnrs/gnrs_3_update.sh"	

# Check primary keys of main tables
source "$DIR/checks/check_pks.sh"

######################################################
# Import results of CDS validations
######################################################

echoi $e "-----------------------------------"
echoi $e "Importing results of CDS validations:"
source "$DIR/cds/cds_3_update.sh"	
source "$DIR/checks/check_pks.sh"

######################################################
# Import political division reference tables
# Needed to fix FIA plot codes in next step
######################################################

echoi $e "-----------------------------------"
source "$DIR/poldiv_tables/poldiv_tables.sh"

######################################
# Update column is_new_world
######################################
echoi $e "-----------------------------------"
source "$DIR/is_new_world/is_new_world.sh"	

######################################################
# Extract file of political divisions and coordinates
# for point-in-polygon geovalidation & centroids
# 
# Currently not used for geovalidation now that this 
# is done in pipeline by module pdg. May be deprecated
# in future once centroids added to pipeline as well.
######################################################
echoi $e "-----------------------------------"
source "$DIR/is_geovalid/is_geovalid.sh"
source "$DIR/checks/check_pks.sh"

######################################################
# Fix plot codes in legacy FIA data
#
# Run after GNRS to allow use of standardized 
# political division fields
######################################################

echoi $e "-----------------------------------"
source "$DIR/fix_fia/fix_fia.sh"

######################################################
# NSR: export taxon names + political divisions for
# scrubbing
######################################################
echoi $e "-----------------------------------"
source "$DIR/nsr/nsr_1_prepare.sh"

######################################################
# CODS: Export scrubbed coordinates and specimen
# descriptions for validation by CDS
######################################################
echoi $e "-----------------------------------"

source "$DIR/cods/cods_1_prepare.sh"	

######################################################
# Echo final instructions
######################################################

msg_next_steps="$(cat <<-EOF

Script completed. Next step:

1. Submit CODS input for scrubbing
2. Submit NSR input for scrubbing
4. After steps 1-2 complete, continue with adb_private_3_import_validations_2.sh

EOF
)"
echoi $e "$msg_next_steps"

######################################################
# Report total elapsed time and exit
######################################################

# Restore process name in case reset by sourced script
pname=$pname_master
source "$DIR/includes/finish.sh"
