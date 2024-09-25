#!/bin/bash

#########################################################################
# Purpose: Step 3 of BIEN database pipeline. 
#
# Details: Import results of CODS and NSR validations. Create and/or
# 	update remaining metadata tables. Export preliminary data dictionary 
# 	and datasource files for manual editing.
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


######################################################
# Import results of CODS and NSR validations
# Check PKs in main tables still unique after each import
######################################################

echoi $e "-----------------------------------"
source "$DIR/cods/cods_3_update.sh"	
source "$DIR/checks/check_pks.sh"

echoi $e "-----------------------------------"
source "$DIR/nsr/nsr_3_update.sh"	
source "$DIR/checks/check_pks.sh"

######################################
# Last fixes to adb tables 
######################################
echoi $e "-----------------------------------"
echoi $e "Making last fixes to main tables before indexing:"
echoi $e " "

echoi $e "- Dropping indexes from tables:"
echoi $e -n "-- view_full_occurrence_individual..."
drop_indexes -q -p -u $user -d $db_private -s $dev_schema -t "view_full_occurrence_individual_dev"
echoi $e "done"

echoi $e -n "-- agg_traits..."
drop_indexes -q -p -u $user -d $db_private -s $dev_schema -t "agg_traits"
echoi $e "done"

echoi $e -n "- Fixing negative plot areas..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR/plot_metadata/sql/fix_negative_plot_areas.sql
source "$DIR/includes/check_status.sh"

# Added earlier in pipeline
# Remove this step after BIEN 4.2 complete
echoi $e -n "- Creating table taxon_status..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR/bien_taxonomy/sql/create_taxon_status.sql
source "$DIR/includes/check_status.sh"

# Added earlier in pipeline
# Remove this step after BIEN 4.2 complete
echoi $e -n "- Adding alias columns to bien_taxonomy..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR/bien_taxonomy/sql/add_alias_columns.sql
source "$DIR/includes/check_status.sh"

# Added earlier in pipeline
# Remove this step after BIEN 4.2 complete
echoi $e -n "- Adding column is_embargoed to table taxon..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR/endangered_taxa/sql/update_endangered_taxa.sql
source "$DIR/includes/check_status.sh"

#
# Include next three to step in module poldiv_tables (next time around)
#
echoi $e "- Adding column continent to table:"
echoi $e -n "-- vfoi..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR/poldiv_tables/sql/add_continent_vfoi.sql
source "$DIR/includes/check_status.sh"

echoi $e -n "-- agg_traits..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR/poldiv_tables/sql/add_continent_agg_traits.sql
source "$DIR/includes/check_status.sh"

echoi $e -n "-- plot_metadata..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v sch=$dev_schema -f $DIR/poldiv_tables/sql/add_continent_plot_metadata.sql
source "$DIR/includes/check_status.sh"

######################################
# Update analytical_stem 
######################################
echoi $e "-----------------------------------"
# Transfer all updated columns from vfoi to astem
source "$DIR/analytical_stem/analytical_stem.sh" 

######################################################
# Remaining adjustments to schemas of major tables,
# if any
######################################################
# NOT NEEDED BIEN 4.2
# echoi $e "-----------------------------------"
# source "$DIR/update_schema/update_schema.sh"

######################################################
# Populate & index spatial columns 
# Do this after final schema changes and before 
# indexing of completed tables
######################################################

echoi $e "-----------------------------------"
source "$DIR/populate_geom/populate_geom.sh"

######################################################
# Import/add world_geom tables and scrub with GNRS
# UNDER CONTRUCTION!
######################################################

# echoi $e "-----------------------------------"
# source "$DIR/world_geom/world_geom.sh"

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
# Make final metadata & summary tables and tidy up
######################################################
echoi $e "-----------------------------------"
echoi $e "Making final metadata tables:"
echoi $e " "

# set parameters for next step
db=$db_private; dev_schema=$dev_schema_adb_private
source "$DIR/trait_metadata/trait_metadata.sh"

# A couple more summary tables
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
# IS THIS STILL NEEDED?
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
#source "$DIR/cleanup/cleanup.sh"
echoi $e "Skipping cleanup! Do manually, then build data dictionary"
echoi $e " "
echo "EXITING script `basename "$BASH_SOURCE"`"; exit 0

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
