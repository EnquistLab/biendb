#!/bin/bash

##############################################################
# Application parameters
# Check and change as needed
##############################################################

# Db and schema to validate
db=$db_public
sch=$prod_schema_adb_public

# Set process names, for notification and screen echo,
# depending on which is being run
if [ "$local_basename" == "vacuum" ]; then
	pname_local="VACUUM ANALYZE"
else
	pname_local="$local_basename"
fi
