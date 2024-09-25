##################################################################
# Halts execution if all values of column $col in table $tbl are 
# not unique. Use to check for PK violations when PK contraints 
# are temporarily removed
#
# Requires global params $user, $db_private, $dev_schema_adb_private
##################################################################

echoi $e ""
echoi $e -n "Checking primary keys..."

pks_unique="t"

# Check table view_full_occurrence_individual_dev
tbl="view_full_occurrence_individual_dev"
col="taxonobservation_id"

echoi $e -n "$tbl..."
col_unique=$(is_unique_psql -u $user -d $db_private -s $dev_schema_adb_private -t $tbl -c $col )
if [[ "$col_unique" == "f" ]]; then
	echo "ERROR: PK column \"$col\" in table \"$tbl\" NOT UNIQUE!"
	pks_unique="f"
fi

if [[ "$pks_unique" == "f" ]]; then 
	echo "Exiting due to one or more PK violations."; exit 1
else
	echoi $e "done"
	echoi $e ""
fi 

# Reset to traceable nonsense to avoid contaminating globals
tbl="_value_from_validations_check_pks_"
col="_value_from_validations_check_pks_"