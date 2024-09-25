#!/bin/bash

##############################################################
# Local application parameters
# Check and change as needed
##############################################################

# Db and schema to validate
db=$db_private
sch="analytical_db_dev"

# Current names of main adb tables
# Will have '_dev' suffix if validating development db before
# final name changes
vfoi='view_full_occurrence_individual_dev'

# Data directory
# Temp files saved here
data_dir="data"

# Match threshold. Match and resolution results will be deleted for
# names with Overall_score below this value.
match_threshold=0.53

# Set process names, for notification and screen echo,
# depending on which is being run
if [ "$local_basename" == "validate_db_dev_private" ]; then
	pname_local="Validate Private ADB (dev version)"
else
	pname_local="$local_basename"
fi
