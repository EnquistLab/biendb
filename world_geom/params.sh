#!/bin/bash

##############################################################
# Application parameters
# Check and change as needed
##############################################################

# Size of batches to be processed
# Strongly recommend 100000; gives fastest overall processing time
BATCHSIZE=100000

# Tables to be validated
# All validation fields MUST be the same in all tables
# Each line is a table name, no comma at end of line
target_tbls="
view_full_occurrence_individual_dev
agg_traits
"

# Name of spatial reference table containing 
# political division polygons to be matched
ref_tbl="world_geom"

# Name of temporary integer PK
# Will be added to each table for calculating batches, then 
# removed after operation complete. Make sure name does not
# conflict with any existing column in any target table
pk_temp="super_temporary_pk"		

# Default development schema
# Convert specific parameter from main params file to generic
dev_schema=$dev_schema_adb_private

# Temp tables of validation input/output
tbl_submitted="pdg_submitted"			# Values for scrubbing
tbl_results="pdg_results"					# Scrubbing results

# Validation file names
submitted_filename="pdg_submitted.csv"	# Validation input file
results_filename="pdg_results.csv"		# Validation results file

# Absolute path to data directory
# Set this value to absolute path if you wish to keep outside
# of top-level application directory. Otherwise, if you comment
# out or do not use an absolute path (ie., starting with '/')
# then this value will be ignored and relative path inside main
# application directory will be used
validation_app_data_dir="/home/boyle/bien3/pdg/userdata"
data_dir_local_abs=$gnrs_data_dir

# Set process names, for notification and screen echo,
# depending on which is being run
if [ "$local_basename" == "pdg_1_prepare" ]; then
	pname_local="Political division geovalidation: prepare"
elif [ "$local_basename" == "pdg_2_scrub" ]; then
	pname_local="Political division geovalidation: scrub"
elif [ "$local_basename" == "pdg_2_scrub_pdg" ]; then
	pname_local="Political division geovalidation: scrub (temp)"
elif [ "$local_basename" == "pdg_2_scrub_continue" ]; then
	pname_local="Political division geovalidation: scrub"
elif [ "$local_basename" == "pdg" ]; then
	pname_local="Political division geovalidation"
else
	echo "ERROR: \"$local_basename\" - Incorrect process name, check params file"; exit 1
fi

###################################################
# Parameters used only by provisional scripts 
# pdg_1_prepare.sh & pdg_2_scrub.sh
###################################################

# Source schema from which existing table world_geom will be imported
src_schema=$prod_schema_adb_private
gnrs_submitted_filename="gnrs_submitted.csv"
gnrs_results_filename="gnrs_results.csv"

# Use record limit from global file? Over-rides global $use_limit setting
use_limit_local="false" 

# TEMPORARY! Need to set in main params file
#gnrs_dir="/home/boyle/bien3/repos/gnrs_v1.1.1/gnrs"
