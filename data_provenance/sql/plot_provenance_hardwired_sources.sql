-- 
-- Populates plot data provenance columns for hard-wired datasources
-- 

SET search_path TO :dev_schema;

UPDATE plot_provenance
SET dataset='CTFS Panama Plots',
primary_dataowner='Richard Condit',
primary_dataowner_email='conditr@gmail.com'
WHERE datasource='CTFS';

UPDATE plot_provenance
SET dataset='New Zealand National Vegetation Survey',
primary_dataowner='Susan Wiser',
primary_dataowner_email='WiserS@landcareresearch.co.nz'
WHERE datasource='NVS';

UPDATE plot_provenance
SET dataset='U.S. Forest Inventory and Analysis (FIA) National Program',
primary_dataowner='Greg Reams',
primary_dataowner_email='greams@fs.fed.us'
WHERE datasource='FIA';

UPDATE plot_provenance
SET dataset='The Madidi Project',
primary_dataowner='Peter Jorgensen',
primary_dataowner_email='peter.jorgensen@mobot.org'
WHERE datasource='Madidi';

UPDATE plot_provenance
SET dataset='Carolina Vegetation Survey',
primary_dataowner='Robert Peet',
primary_dataowner_email='peet@unc.edu'
WHERE datasource='CVS';