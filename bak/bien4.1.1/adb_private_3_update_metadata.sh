#!/bin/bash

#########################################################################
# Purpose: Complete major validation update to private BIEN analytical 
#  db, indexes major tables, and builds metadata tables.
#
# Requirements: 
#  Completion of all previous steps through adb_private_2_update_taxa.sh
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

#echo "EXITING script `basename "$BASH_SOURCE"`"; exit 0

: <<'COMMENT_BLOCK_x'
COMMENT_BLOCK_x

######################################
# Update NSR results
######################################

echoi $e "-----------------------------------"
source "$DIR/nsr/nsr_2_update.sh"	

######################################
# Update column is_new_world
######################################
echoi $e "-----------------------------------"
source "$DIR/is_new_world/is_new_world.sh"	

######################################
# Update centroid validations 
######################################
echoi $e "-----------------------------------"
source "$DIR/centroids/centroids_update.sh"	

######################################################
# Add spatial indexes for species observations
# Must come after taxonomic scrubbing and geovalidation
# Deprecated! Now performed by module spatial_indexes
######################################################
# echoi $e "-----------------------------------"
# source "$DIR/vfoi_geom/vfoi_geom.sh"

######################################
# Update analytical_stem 
######################################
echoi $e "-----------------------------------"
# Transfer all updated columns from vfoi to astem
source "$DIR/analytical_stem/analytical_stem.sh" 

######################################
# Update plot_metadata with pdf & 
# centroid valdations results
######################################
# echoi $e "-----------------------------------"
source "$DIR/plot_metadata/update_plot_metadata.sh" 

######################################################
# Remaining adjustments to schemas of major tables,
# if any
######################################################
echoi $e "-----------------------------------"
source "$DIR/update_schema/update_schema.sh"

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
source "$DIR/restore_indexes/restore_indexes_dev.sh"

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

# Insert rbien data dictionary spreadsheet to table   
# data_dictionary_rbien
db=$db_private; dev_schema=$dev_schema_adb_private
source "$DIR/data_dictionary_rbien/data_dictionary_rbien.sh"

# Create tables species and observations_union
source "$DIR/observations_union/observations_union.sh"

######################################################
# Ranges
######################################################

# Copy over ranges table from production public database 
# to private development analytical schema
# TEMPORARY FIX UNTIL DEVELOP NEW RANGES DB
source "$DIR/ranges/cp_ranges.sh"

######################################################
# Phylogenies
######################################################

# Copy phylogenies from previous versions of BIEN DB
# TEMPORARY FIX UNTIL DEVELOP NEW PHYLOGENIES
echoi $e "-----------------------------------"
if [[ $load_phylo == "true" ]]; then
	source "$DIR/phylogeny/phylogeny.sh"
else
	echoi $e "Loading phylogenies...SKIPPING THIS STEP"
fi

######################################################
# Clean up
######################################################
echoi $e "-----------------------------------"
source "$DIR/cleanup/cleanup.sh"
# echoi $e "Skipping cleanup! Do manually"
# echoi $e " "

######################################################
# Create data dictionary based on "cleaned" schema
######################################################

echoi $e "-----------------------------------"
source "$DIR/data_dictionary/data_dictionary_1_create.sh"	

######################################################
# Echo final instructions
######################################################

msg_next_steps="$(cat <<-EOF

Script completed. Next step:

1. Complete manual edits to datasource.csv (see module datasource/)
2. Complete manual edits to dd_tables.csv (see module data_dictionary/)
3. Complete manual edits to dd_cols.csv (see module data_dictionary/)
4. Complete manual edits to dd_vals.csv (see module data_dictionary/)
5. Rename all revised manual edit files with suffix '_revised' (e.g.,  
   'datasource_revised.csv' and place in the appropriate data directories.  
6. Update database by running adb_private_4_final_update.sh
7. Perform manual cleanup as needed

EOF
)"
echoi $e "$msg_next_steps"

######################################################
# Report total elapsed time and exit
######################################################

# Restore process name in case reset by sourced script
pname=$pname_master
source "$DIR/includes/finish.sh"
