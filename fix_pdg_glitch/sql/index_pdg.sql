set search_path to :sch;


DROP INDEX IF EXISTS pdg_tbl_name_idx;
DROP INDEX IF EXISTS pdg_tbl_id_idx;
DROP INDEX IF EXISTS pdg_tbl_id_idx;

CREATE INDEX pdg_tbl_name_idx ON pdg (tbl_name);
CREATE INDEX pdg_tbl_id_idx ON pdg (tbl_id);
CREATE INDEX pdg_country_idx ON pdg (country);
