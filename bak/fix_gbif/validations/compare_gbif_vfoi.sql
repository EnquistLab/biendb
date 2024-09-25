-- -----------------------------------------------------------------
-- Confirm relationship between GBIF extracts and vfoi records
-- -----------------------------------------------------------------


-- plants file
SELECT datasource, dataset, "institutionCode", country, "countryCode", 
verbatim_scientific_name, "scientificName"
FROM view_full_occurrence_individual a JOIN gbif_all_plants_raw b
ON a.occurrence_id=b."gbifID"
LIMIT 12
;

-- fossils file
SELECT datasource, dataset, "institutionCode", country, "countryCode", 
verbatim_scientific_name, "scientificName"
FROM view_full_occurrence_individual a JOIN gbif_fossils_raw b
ON a.occurrence_id=b."gbifID"
LIMIT 12
;