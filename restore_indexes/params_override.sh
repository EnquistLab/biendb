#!/bin/bash

##############################################################
# Override of any parameters set previously
# Only loaded if $params_override="t" (set in params.sh
# for this module)
#
# Note:
# * Existing values are back up as <param>_orig
# * In theory, this script should only be loaded if running as
#   standalone module, however...
# * To be safe, restore all variables set here in params_restore.sh
##############################################################

db_orig=$db
db=$db_private

sch_orig=$sch
sch=$prod_schema_adb_private

pname_local="Restore all indexes (new)"
pname_local_header="BIEN notification: process '"$pname_local"'"
