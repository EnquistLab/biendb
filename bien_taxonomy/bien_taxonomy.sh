#!/bin/bash

#########################################################################
# Purpose: Creates & populate complete table bien_taxonomy
#
# Details:
#   Table bien_taxonomy is an extract of all distinct taxa, including
#   authors and morphospecies, from main bien analytical database
#   'view_full_occurrence_individual'. Other columns added include 
#   (1) Integer primary key, (2) higher taxa, and (3) taxonomic status
#   of the final resolved name.
#
# Authors: Brad Boyle (bboyle@email.arizona.edu)
# Date created: 23 July 2016
#########################################################################

: <<'COMMENT_BLOCK_x'
COMMENT_BLOCK_x

######################################################
# Set parameters, load functions & confirm operation
# 
# Loads local parameters only if called by master script.
# Otherwise loads all parameters, functions and options
######################################################

# Get local working directory
DIR_LOCAL="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR_LOCAL" ]]; then DIR_LOCAL="$PWD"; fi

# $local = name of this file
# $local_basename = name of this file minus ='.sh' extension
# $local_basename should be same as containing directory, as  
# well as local data subdirectory within main data directory, 
# if local data directory needed
local=`basename "${BASH_SOURCE[0]}"`
local_basename="${local/.sh/}"

# Set parent directory if running independently
if [ -z ${master+x} ]; then
	DIR=$DIR_LOCAL"/.."
fi

# Load startup script for local files
# Sets remaining parameters and options, and issues confirmation
# and startup messages
source "$DIR/includes/startup_local.sh"	

#########################################################################
# Main
#########################################################################

echoi $e "Executing module 'bien_taxonomy'"

######################################################
# Check if required taxonomic databases exist
######################################################

# Check if tnrs & genus databases present
echoi $e -n "- Checking required databases..."
if ! psql -lqt | cut -d \| -f 1 | grep -qw $tnrs_db; then
	echo; echo "ERROR: Required database '$tnrs_db' missing"; echo 
	exit 1
fi
if ! psql -lqt | cut -d \| -f 1 | grep -qw $genus_family_db; then
	echo; echo "ERROR: Required database '$genus_family_db' missing"; echo 
	exit 1
fi
source "$DIR/includes/check_status.sh"	

######################################################
# Import genus-family lookup table
######################################################

echoi $e "- Copying table 'genus_family' from db '$genus_family_db' to schema '$dev_schema' in db '$db_private':"

# Dump table from source databse
echoi $e -n "-- Creating dumpfile..."
dumpfile=$data_dir_local"/genus_family.sql"
pg_dump -U $user -t genus_family $genus_family_db > $dumpfile
source "$DIR/includes/check_status.sh"	

# Replace schema references. Be very conservative to avoid 
# corrupting data which matches schema name 
# Recommend stopping first time prior to point to inspect dumpfile
# to be sure that substitutions are correct
# NOTE USE OF DOUBLE QUOTES! VARIABLE $dev_schemaIS NOT TRANSLATED IF
# SINGLE QUOTES USED
echoi $e -n "-- Editing dumpfile..."
sed -i -e "s/public, pg_catalog/$dev_schema/g" $dumpfile
sed -i -e "s/Schema: public/Schema: $dev_schema/g" $dumpfile
sed -i -e "s/public.genus_family/$dev_schema.genus_family/g" $dumpfile 
source "$DIR/includes/check_status.sh"	

# Drop the table in core database if it already exists
#echoi $e -n "-- Dropping previous table, if any..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -c "DROP TABLE IF EXISTS $dev_schema.genus_family"
#source "$DIR/includes/check_status.sh"	

# Import table from dumpfile to target db & schema
echoi $e -n "-- Importing table from dumpfile..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -q --set ON_ERROR_STOP=1 $db_private < $dumpfile > /dev/null >> $tmplog
#source "$DIR/includes/check_status.sh"	

#echoi $e -n "-- Removing dumpfile..."
rm $dumpfile
source "$DIR/includes/check_status.sh"	

######################################################
# Create tablebien_taxonomy, extract taxonomy and 
# add indexes
######################################################

echoi $e -n "- Creating table bien_taxonomy..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/create_bien_taxonomy.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Loading table bien_taxonomy..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/load_bien_taxonomy.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Populating FK to bien_taxonomy in tnrs results table..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/tnrs_bien_taxonomy_fk.sql
source "$DIR/includes/check_status.sh"	

######################################################
# Add missing families based on genus
######################################################

# Populate missing families by joining by genus to g-f lookup table
echoi $e -n "- Adding missing families..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/add_missing_families.sql
source "$DIR/includes/check_status.sh"	

# Populate taxon_rank column
echoi $e -n "- Populating taxon_rank..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/bien_taxonomy_detect_rank.sql
source "$DIR/includes/check_status.sh"	

######################################################
# Move bien_taxonomy to TNRS database
######################################################

# Create development schema in tnrs database if not already present
# Dumpfile not needed because no naming conflicts
echoi $e -n "- Copying table bien_taxonomy to tnrs database..."

PGOPTIONS='--client-min-messages=warning' psql -U $user -d $tnrs_db --set ON_ERROR_STOP=1 -q -c "CREATE SCHEMA IF NOT EXISTS $dev_schema"

# Drop the table in destination database & schema, in case already exists
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $tnrs_db --set ON_ERROR_STOP=1 -q -c "DROP TABLE IF EXISTS $dev_schema.bien_taxonomy CASCADE"

# Dump the table directly to tnrs database
pg_dump -U $user -t $dev_schema.bien_taxonomy $db_private | PGOPTIONS='--client-min-messages=warning' psql -U $user -q --set ON_ERROR_STOP=1 $tnrs_db > /dev/null >> $tmplog

source "$DIR/includes/check_status.sh"	

######################################################
# Populate remaining higher taxa
# Note that all operation in this step are in TNRS db
######################################################

# Check if required higher taxon tables existsin development schema  
# of TNRS database
ht_exists=$(exists_table_psql -d $tnrs_db -u $user -s $dev_schema -t 'higher_taxa' )
mht_exists=$(exists_table_psql -d $tnrs_db -u $user -s $dev_schema -t 'multiple_higher_taxa' )

# Build tables if they don't already exist
# Can force rebuild by setting $higher_taxa_force_replace='true'
# in local params file
echoi $e -n "- Creating tables of APGIII higher taxa..."
if [[ $ht_exists == "f" || $mht_exists == "f" || $higher_tax_force_replace == "true" ]]; then
	PGOPTIONS='--client-min-messages=warning' psql -U $user -d $tnrs_db --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/higher_taxon_table.sql
	now=`date +%s%N`; elapsed=`echo "scale=2; ($now - $prev) / 1000000000" | bc`; 
	source "$DIR/includes/check_status.sh"	
else
	echoi $e "using existing tables"
fi

echoi $e -n "- Populating higher taxon columns in bien_taxonomy..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $tnrs_db --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/update_higher_taxa.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Populating column higher_plant_group..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $tnrs_db --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/higher_plant_group.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "- Correcting errors in higher taxon columns..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $tnrs_db --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/fix_higher_taxa.sql
source "$DIR/includes/check_status.sh"	

######################################################
# Move bien_taxonomy back to development schema in 
# original database
######################################################

echoi $e -n "- Replacing original table bien_taxonomy in development schema..."

# Drop the original table in original database
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -c "DROP TABLE IF EXISTS $dev_schema.bien_taxonomy"

# Copy the table
pg_dump -U $user -t $dev_schema.bien_taxonomy $tnrs_db | PGOPTIONS='--client-min-messages=warning' psql -U $user -q --set ON_ERROR_STOP=1 $db_private > /dev/null >> $tmplog

source "$DIR/includes/check_status.sh"	

######################################################
# Add aliases for columns "order" and "class"
# 
# Aliases provide alternative access to these columns for third
# party applications (such as BIEN API) if the above column names
# trigger reserved word errors.# Add alias columns to bien_taxonomy.
# BIEN 4.1.1 fix added to pipeline.
######################################################

echoi $e -n "- Adding alias columns to table bien_taxonomy..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/add_alias_columns.sql
source "$DIR/includes/check_status.sh"	

######################################################
# Add table taxon_status (taxon taxonomic status)
# 
# BIEN 4.1.1 fix added to pipeline
######################################################

echoi $e -n "- Creating & populating table taxon_status..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/create_taxon_status.sql
source "$DIR/includes/check_status.sh"	

######################################################
# Make normalized taxon table & populate FKs in 
# bien_taxonomy
######################################################

echoi $e "- Building normalized taxon table:"

echoi $e -n "-- Creating table taxon..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/create_taxon.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "-- Loading table taxon..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/load_taxon.sql > /dev/null >> $tmplog
source "$DIR/includes/check_status.sh"	

echoi $e -n "-- Populating remaining columns and indexing..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/index_taxon.sql 
source "$DIR/includes/check_status.sh"	

echoi $e -n "-- Populating FKs in table bien_taxonomy..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/taxon_bien_taxonomy_fks.sql
source "$DIR/includes/check_status.sh"	

# Check that candidate pkey field poldiv_full is still unique
# Throw error and abort if not
echoi $e -n " - Verifying candidate primary key unique:"
check_pk -u $user -d $db -s $dev_schema -t bien_taxonomy -c bien_taxonomy_id

######################################################
# Update results to main tables
######################################################

echoi $e "- Transferring taxonomy results to table:"

echoi $e -n "-- agg_traits..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/update_agg_traits.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "-- vfoi..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/update_vfoi.sql
source "$DIR/includes/check_status.sh"	

echoi $e -n "-- endangered_taxa_by_source..."
PGOPTIONS='--client-min-messages=warning' psql -U $user -d $db_private --set ON_ERROR_STOP=1 -q -v dev_schema=$dev_schema -f $DIR_LOCAL/sql/update_endangered.sql
source "$DIR/includes/check_status.sh"	

######################################################
# Report total elapsed time and exit if running solo
######################################################

if [ -z ${master+x} ]; then source "$DIR/includes/finish.sh"; fi