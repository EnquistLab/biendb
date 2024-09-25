##################################################################
# Count rows in table $checktbls in schema $checksch and echo results
#
# Requires global params $user, $db_private, $dev_schema_adb_private
##################################################################

echoi $e "Checking row counts in table:"

##########################################
# Parameters
# (make these command line parameters when have time...)
##########################################

# schema to check
# Set to "" if not schema qualifier needed
checksch=$dev_schema_adb_private

# Tables to check
# Make this a parameter when have time...
checktbls="
view_full_occurrence_individual_dev
agg_traits
"

##########################################
# Main
##########################################

if [ ! "$checksch" == "" ]; then
	checksch=$checksch"."
fi

for checktbl in $checktbls; do
	echoi $e -n "- $checktbl..."
	schtbl="${checksch}${checktbl}"
	rows=$(count_rows_psql -u $user -d $db_private -t $schtbl )
	echoi $e "$rows"
done

# Reset to traceable nonsense to avoid contaminating globals
checksch="_checksch_empty_"
checktbls="_checktbls_empty_"
checktbl="_checktbl_empty_"