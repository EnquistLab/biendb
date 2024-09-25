-- --------------------------------------------------------------------
-- Add column geovalid_fail_reason & mark invalid or missing coordinates
-- --------------------------------------------------------------------


set search_path to analytical_db_dev;

ALTER TABLE view_full_occurrence_individual
ADD COLUMN geovalid_fail_reason text default null
;

update agg_traits
set is_geovalid=0,
geovalid_fail_reason='Null coordinates'
where latitude is null or longitude is null
;
update agg_traits
set is_geovalid=0,
geovalid_fail_reason='Impossible coordinates'
where latitude>90 or latitude<-90 or longitude>180 or longitude<-180
;

update view_full_occurrence_individual
set is_geovalid=0,
geovalid_fail_reason='Null coordinates'
where latitude is null or longitude is null
;
update view_full_occurrence_individual
set is_geovalid=0,
geovalid_fail_reason='Impossible coordinates'
where latitude>90 or latitude<-90 or longitude>180 or longitude<-180
;

