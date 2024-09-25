-- 
--  Update misc plot metadata in table plot_metadata
--

SET search_path TO :dev_schema;

UPDATE plot_metadata
SET sampling_protocol='US Forest Inventory and Analysis Sampling Protocol',
methodology_reference='http://www.fia.fs.fed.us/library/field-guides-methods-proc/',
abundance_measurement='individuals'
WHERE datasource IN (
'CTFS',
'TEAM',
'Madidi',
'FIA'
)
;

UPDATE plot_metadata
SET sampling_protocol='US Forest Inventory and Analysis Sampling Protocol',
methodology_reference='http://www.fia.fs.fed.us/library/field-guides-methods-proc/',
abundance_measurement='individuals'
WHERE datasource='FIA'
;

UPDATE plot_metadata
SET sampling_protocol='TEAM Forest Inventory Sampling Protocol',
methodology_reference='http://www.teamnetwork.org/protocols/bio/vegetation',
abundance_measurement='individuals'
WHERE datasource='TEAM'
;

UPDATE plot_metadata
SET sampling_protocol='Center for Tropical Forest Science Forest Inventory  Protocol',
methodology_reference='http://www.forestgeo.si.edu/',
abundance_measurement='individuals'
WHERE datasource='CTFS'
;

UPDATE plot_metadata
SET sampling_protocol='Madidi forest inventories',
methodology_reference='http://www.missouribotanicalgarden.org/plant-science/plant-science/south-america/the-madidi-project.aspx',
abundance_measurement='individuals'
WHERE datasource='Madidi'
;

