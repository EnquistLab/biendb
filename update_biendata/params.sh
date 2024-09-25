#!/bin/bash

##############################################################
# Application parameters
# Check and change as needed
##############################################################

# Db and schema to validate
db=$db_public
sch=$dev_schema_adb_public

# Set process names, for notification and screen echo,
# depending on which is being run
if [ "$local_basename" == "update_biendata" ]; then
	pname_local="Update biendata.org"
else
	pname_local="$local_basename"
fi

