-- Compare verbatim and matched name, vfoi only
SELECT 
fk_tnrs_id,
verbatim_family, verbatim_scientific_name,
family_matched,
name_matched,
name_matched_author,
matched_taxonomic_status as matched_status, 
match_summary
FROM view_full_occurrence_individual_dev
LIMIT 12
;

-- Compare verbatim and scrubbed name, vfoi only
SELECT 
fk_tnrs_id,
verbatim_family, verbatim_scientific_name,
name_submitted,
higher_plant_group, 
scrubbed_family,
scrubbed_taxonomic_status as scrubbed_status, 
scrubbed_taxon_name_with_author as scrubbed_taxon_with_author
FROM view_full_occurrence_individual_dev
LIMIT 12
;

-- Compare joining by tnrs_id
SELECT 
tnrs_id,
TRIM(CONCAT_WS(' ',vfoi.verbatim_family, vfoi.verbatim_scientific_name)) AS vfoi_verbatim_name,
vfoi.name_submitted as vfoi_name_submitted,
tnrs.name_submitted as tnrs_name_submitted,
tnrs.name_matched as tnrs_name_matched,
vfoi.scrubbed_taxon_name_no_author as tnrs_scrubbed_taxon
FROM tnrs JOIN view_full_occurrence_individual_dev as vfoi
ON tnrs.tnrs_id=vfoi.fk_tnrs_id
LIMIT 12
;




