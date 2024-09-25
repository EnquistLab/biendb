set search_path to :sch;

DROP TABLE IF EXISTS agg_traits_geovalid_bak;
CREATE TABLE agg_traits_geovalid_bak AS
SELECT id, is_in_country, is_in_state_province, is_in_county, is_geovalid
FROM agg_traits
;

DROP TABLE IF EXISTS vfoi_geovalid_bak;
CREATE TABLE vfoi_geovalid_bak AS
SELECT taxonobservation_id, is_in_country, is_in_state_province, is_in_county, is_geovalid
FROM view_full_occurrence_individual
;