-- 
-- Raw data table for this source
--

SET search_path TO :sch;

DROP TABLE IF EXISTS "gillespie_people_raw";
CREATE TABLE "gillespie_people_raw" (
"first_name" text,
"last_name" text,
"initials" text,
"is_pi" text,
"is_collector" text,
"collector_code" text,
"email" text,
"phone" text,
"fax" text,
"url" text,
"institution_code" text,
"department" text,
"junk" text
);

DROP TABLE IF EXISTS "gillespie_plot_descriptions_raw";
CREATE TABLE "gillespie_plot_descriptions_raw" (
"plot_code" text,
"plot_full_name" text,
"country" text,
"state" text,
"pol2" text,
"pol3" text,
"locality_description" text,
"lat_dec" text,
"long_dec" text,
"elev_m" text,
"elev_max_m" text,
"elev_min_m" text,
"tot_ann_precip_mm" text,
"mean_ann_temp_c" text,
"precip_source" text,
"temp_source" text,
"holdridge_life_zone" text,
"habitat_description" text,
"size_cutoff_min" text,
"excluded_forms" text,
"plot_area_ha" text,
"method_description" text,
"recensused" text,
"date_start" text,
"date_finish" text,
"plot_notes" text
);

DROP TABLE IF EXISTS "gillespie_plot_data_raw";
CREATE TABLE "gillespie_plot_data_raw" (
"plot_code" text,
"subplot" text,
"ind_no" text,
"collection_number" text,
"collector_code" text,
"morphoname" text,
"family" text,
"species" text,
"author" text,
"cfaff" text,
"habit" text,
"height_m" text,
"dbh1" text,
"dbh2" text,
"dbh3" text,
"dbh4" text,
"dbh5" text,
"dbh6" text,
"dbh7" text,
"dbh8" text,
"dbh9" text,
"dbh10" text,
"dbh11" text,
"dbh12" text,
"dbh13" text,
"dbh14" text,
"dbh15" text,
"comments" text,
"junk" text,
"junk2" text
);