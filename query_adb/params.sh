#!/bin/bash

##############################################################
# Application parameters
# Check and change as needed
##############################################################

# Db and schema to validate
db=$db_private
sch=$dev_schema_adb_private

# Current names of main adb tables
# Will have '_dev' suffix if validating development db before
# final name changes
vfoi='view_full_occurrence_individual_dev'
astem='analytical_stem_dev'

# Set process names, for notification and screen echo,
# depending on which is being run
if [ "$local_basename" == "validate_db_dev_private" ]; then
	pname_local="Validate Private ADB (dev version)"
else
	pname_local="$local_basename"
fi

#########################################
# Params specific to range_model_data.sh
#########################################

# Theshold number of observations, above which the full where clause
# is applied; below this, filters "is_introduced" and "observation_type"
# are omitted
obs_threshold=100
