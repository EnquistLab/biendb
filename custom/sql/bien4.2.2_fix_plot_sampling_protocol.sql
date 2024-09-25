-- -------------------------------------------------------------------
-- Add full plot methodology to column sampling_protocol for 
-- dataset='Gentry Transect Dataset' and copy over all values of 
-- sampling_protocol to plot_metadata. For some reason, 
-- plot_metadata.sampling_protocol is null for some datasets
-- Also fix other mysterious glithces. No idea...
--
-- NOT ADDED TO PIPELINE
-- Date: 20 Sept. 2021
-- -------------------------------------------------------------------

SET search_path TO :sch;

UPDATE plot_metadata
SET sampling_protocol='0.1 ha  transect, stems >= 2.5 cm dbh'
WHERE datasource IN (
'Madidi',
'gillespie'
)
;
UPDATE plot_metadata
SET sampling_protocol='0.1 ha  transect, stems >= 2.5 cm dbh'
WHERE datasource='SALVIAS' 
AND dataset IN (
'Bonifacino Forest Transects',
'Brad Boyle Forest Transects',
'DeWalt Bolivia forest plots',
'La Selva Secondary Forest Plots',
'Noel Kempff Forest Plots'
)
;
UPDATE plot_metadata
SET sampling_protocol='1 ha, stems >= 10 cm dbh'
WHERE datasource IN (
'TEAM',
'CTFS'
)
;
UPDATE plot_metadata
SET sampling_protocol='1 ha, stems >= 10 cm dbh'
WHERE datasource='SALVIAS' 
AND dataset IN (
'RAINFOR - 1 ha Peru',
'Pilon Lajas Treeplots Bolivia'
)
;
UPDATE plot_metadata
SET sampling_protocol='0.1 ha  transect, stems >= 2.5 cm dbh (Warning: species + count of individuals + stem DBHs recorded once per subplot. Individuals not linked to stems)'
WHERE datasource='SALVIAS'
AND dataset='Gentry Transect Dataset'
;
UPDATE plot_metadata
SET sampling_protocol='Carolina Vegetation Survey Sampling Methodology',
methodology_reference='http://cvs.bio.unc.edu/methods.htm'
WHERE datasource='CVS'
;
UPDATE plot_metadata
SET sampling_protocol='Method varies by plot, see www.vegbank.org'
WHERE datasource='VegBank'
;
UPDATE plot_metadata
SET sampling_protocol='NVS Recce protocol, see https://nvs.landcareresearch.co.nz/Resources/FieldManual',
methodology_reference='https://nvs.landcareresearch.co.nz/Resources/FieldManual'
WHERE datasource='NVS'
;
UPDATE plot_metadata
SET sampling_protocol=NULL,
methodology_reference=NULL
WHERE datasource='CTFS'
;
UPDATE plot_metadata
SET sampling_protocol='50 ha, stems>=1 cm dbh [counts of individuals only, stem data not in BIEN]',
methodology_reference='https://repository.si.edu/handle/10088/20925'
WHERE datasource='CTFS' AND plot_name='bci'
;
UPDATE plot_metadata
SET sampling_protocol='1 ha, stems >= 10 cm dbh [counts of individuals only, stem data not in BIEN]',
methodology_reference='https://repository.si.edu/handle/10088/20925'
WHERE datasource='CTFS' AND plot_area_ha=1.000
;
UPDATE plot_metadata
SET sampling_protocol='Method varies by plot, see https://repository.si.edu/handle/10088/20925 [counts of individuals only, stem data not in BIEN]',
methodology_reference='https://repository.si.edu/handle/10088/20925'
WHERE datasource='CTFS' AND sampling_protocol IS NULL
;

--
-- Update the analytical tables
-- 

UPDATE analytical_stem a
SET sampling_protocol=b.sampling_protocol
FROM plot_metadata b
WHERE a.plot_metadata_id=b.plot_metadata_id
;
UPDATE view_full_occurrence_individual a
SET sampling_protocol=b.sampling_protocol
FROM plot_metadata b
WHERE a.observation_type='plot'
AND a.plot_metadata_id=b.plot_metadata_id
;
