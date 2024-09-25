-- 
-- Corrections best done to raw data
--

SET search_path TO :sch;

ALTER TABLE gillespie_plot_data_raw ADD COLUMN "id" bigserial PRIMARY KEY;

-- Create indexes
CREATE INDEX gillespie_plot_descriptions_raw_plot_code_idx ON gillespie_plot_descriptions_raw (plot_code);
CREATE INDEX gillespie_plot_data_raw_plot_code_idx ON gillespie_plot_data_raw (plot_code);

-- Add PK
ALTER TABLE gillespie_plot_descriptions_raw ADD PRIMARY KEY ("plot_code");

-- Add FK
ALTER TABLE gillespie_plot_data_raw 
ADD CONSTRAINT gillespie_plot_data_raw_plot_code_fk1 
FOREIGN KEY ("plot_code") 
REFERENCES gillespie_plot_descriptions_raw ("plot_code")
;
