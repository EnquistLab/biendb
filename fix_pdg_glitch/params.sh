#!/bin/bash

##############################################################
# Application parameters
# Check and change as needed
##############################################################

#sch=$dev_schema_adb_private
sch="analytical_db_dev"

# Set process names, for notification and screen echo
# depending on which is being run
if [ "$local_basename" == "fix_pdg_glitch" ]; then
	pname_local="Fix PDG glitch"
else
	pname_local="$local_basename"
fi

