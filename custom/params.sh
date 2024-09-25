#!/bin/bash

##############################################################
# Local parameters
# Check and change as needed
# In case of name collision with global parameters (in
# ../params.sh) local over-rides global
##############################################################

# Db and schema to validate
db="vegbien"
sch="analytical_db_dev"
#sch="analytical_db_test"
db="public_vegbien"
sch="public"

# Current names of main adb tables
# Will have '_dev' suffix if validating development db before
# final name changes
vfoi='view_full_occurrence_individual'

# Data directory
# Temp files saved here
data_dir="data"

# Match threshold. Match and resolution results will be deleted for
# names with Overall_score below this value.
match_threshold=0.53


# Set process names, for notification and screen echo,
# depending on which is being run

if [ "$local_basename" == "custom_script_template" ]; then
	pname_local="Example of a custom process name"
elif [ "$local_basename" == "bien4.1_data_dump_for_Cory_20181018" ]; then
	pname_local="Custom data dump for Cory"
else
	pname_local="$local_basename"
fi