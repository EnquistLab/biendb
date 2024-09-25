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
vfoi='view_full_occurrence_individual'
astem='analytical_stem'

# Set process names, for notification and screen echo,
# depending on which is being run
if [ "$local_basename" == "validate_db_dev_private" ]; then
	pname_local="Validate Private ADB (dev version)"
else
	pname_local="$local_basename"
fi

# List of required tables
# One table name per line, no commas or quotes
required_tables="
agg_traits
${astem}
bien_metadata
bien_species_all
bien_summary
bien_taxonomy
cds
cites
country
country_name
county_parish
county_parish_name
cods_proximity
cods_keyword
data_contributors
data_dictionary_columns
data_dictionary_rbien
data_dictionary_tables
data_dictionary_values
datasource
endangered_taxa
genus_family
gnrs
ih
iucn
ncbi_taxa
nsr
observations_union
phylogeny
plot_metadata
ranges
species
species_by_political_division
state_province
state_province_name
taxon
taxon_status
taxon_trait
tnrs
trait_summary
usda
${vfoi}
view_indexes
world_geom
world_geom_country
world_geom_county
world_geom_gnrs
world_geom_state
"

# Miscellaneous required columns to check
# Use to check for columns accidentally purged by CREATE TABLE AS operations
# Format: 
# TABLE_NAME,COLUMN_NAME
# One couplet per line, separated by comma, no comma at end, no quotes
required_columns="
${vfoi},geom
agg_traits,geom
${vfoi},continent
agg_traits,continent
${astem},continent
taxon,is_embargoed
bien_taxonomy,taxon_order
bien_taxonomy,taxon_class
"

# Basenames of SQL files containing validation fk checks
# See inidividual files for details
taxonomic_checks="
check_fk_gnrs
check_fk_cds
check_fk_tnrs
check_fk_nsr
check_fk_cods_promimity
check_fk_cods_keyword
"

# Basenames of SQL files containing taxonomic checks
# See inidividual files for details
taxonomic_checks="
unknown_family
nonplant_families
"

# Basenames of SQL files containing geovalid checks
# See inidividual files for details
geovalid_checks="
is_geovalid_missing_coords
is_geovalid_bad_coords
is_geovalid_not_in_poldiv
"

# Tables to check for negative plot areas
plot_area_check_tables="
plot_metadata
${vfoi}
agg_traits
"
# Tables to check for present of validation fkeys
validation_fkeys_check_tables="
${vfoi}
agg_traits
"

# Valiation fkey columns to check
validation_fk_cols="
fk_tnrs_id
fk_gnrs_id
fk_cds_id
nsr_id
cods_proximity_id
cods_keyword_id
"

