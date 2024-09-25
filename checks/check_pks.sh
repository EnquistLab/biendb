#!/bin/bash

##################################################################
# Halts execution if all values of column $col in table $tbl are 
# not unique. Use to check for PK violations when PK contraints 
# are temporarily removed
#
# Requires:
#  Global params $host, $user, $db_private, $dev_schema_adb_private
#  Function check_pk
##################################################################

echoi $e "-----------------------------------"
echoi $e "Checking primary keys of main tables:"
check_pk -h $host -u $user -d $db_private -s $dev_schema_adb_private -t view_full_occurrence_individual_dev -c taxonobservation_id
check_pk -h $host -u $user -d $db_private -s $dev_schema_adb_private -t agg_traits -c "id"

