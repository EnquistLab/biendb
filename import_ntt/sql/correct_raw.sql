-- 
-- Corrections best done to raw data
--

SET search_path TO :sch;


DELETE FROM "ntt_sources_areas_raw"
WHERE "RefID" IS NULL OR "RefID"=''
;
ALTER TABLE "ntt_sources_areas_raw" 
ALTER COLUMN "RefID" TYPE INTEGER 
USING CAST("RefID" AS INTEGER)
;

-- Add PKs
ALTER TABLE ntt_species_raw ADD PRIMARY KEY ("SppID");
ALTER TABLE ntt_areas_raw ADD PRIMARY KEY ("AreaID");
ALTER TABLE ntt_sources_raw ADD PRIMARY KEY ("RefID");
-- ALTER TABLE ntt_species_areas_raw ADD PRIMARY KEY ("AreaID", "SppID");
-- ALTER TABLE ntt_sources_areas_raw ADD PRIMARY KEY ("AreaID", "RefID");

-- Add indices
CREATE INDEX ON ntt_species_areas_raw ("AreaID");
CREATE INDEX ON ntt_species_areas_raw ("SppID");
CREATE INDEX ON ntt_sources_areas_raw ("AreaID");
CREATE INDEX ON ntt_sources_areas_raw ("RefID");

-- Add FKs
ALTER TABLE ntt_species_areas_raw 
ADD CONSTRAINT ntt_species_areas_raw_fk1 
FOREIGN KEY ("AreaID") 
REFERENCES ntt_areas_raw ("AreaID")
;
ALTER TABLE ntt_species_areas_raw 
ADD CONSTRAINT ntt_species_areas_raw_fk2
FOREIGN KEY ("SppID") 
REFERENCES ntt_species_raw ("SppID")
;
ALTER TABLE ntt_sources_areas_raw 
ADD CONSTRAINT ntt_sources_areas_raw_fk1 
FOREIGN KEY ("AreaID") 
REFERENCES ntt_areas_raw ("AreaID")
;
ALTER TABLE ntt_sources_areas_raw 
ADD CONSTRAINT ntt_sources_areas_raw_fk2
FOREIGN KEY ("RefID") 
REFERENCES ntt_sources_raw ("RefID")
;
