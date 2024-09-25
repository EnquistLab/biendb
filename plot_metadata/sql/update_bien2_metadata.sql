-- 
--  Update bien2 plot metadata in table plot_metadata
--

SET search_path TO :dev_schema;

UPDATE metadata_bien2
SET datasourcename=
CASE
WHEN dataSourceName='SALVIAS:Noel Kempff Savanna Plots' THEN 'Noel Kempff Forest Plots'
WHEN dataSourceName='SALVIAS:RAINFOR - 0.1 ha Madre de Dios, Peru' THEN 'RAINFOR - 0.1 ha Madre de Dios, Peru'
WHEN dataSourceName='SALVIAS:Bonifacino Forest Transects' THEN 'Bonifacino Forest Transects'
WHEN dataSourceName='SALVIAS:La Selva Secondary Forest Plots' THEN 'La Selva Secondary Forest Plots'
WHEN dataSourceName='SALVIAS:Cam Webb Borneo Plots' THEN 'Cam Webb Borneo Plots'
WHEN dataSourceName='SALVIAS:DeWalt Bolivia forest plots' THEN 'DeWalt Bolivia forest plots'
WHEN dataSourceName='SALVIAS:Boyle Transects' THEN 'Brad Boyle Forest Transects'
WHEN dataSourceName='SALVIAS:OTS Transects' THEN 'OTS Transects'
WHEN dataSourceName='SALVIAS:Noel Kempff Forest Plots' THEN 'Noel Kempff Savanna Plots'
WHEN dataSourceName='SALVIAS:RAINFOR - 1 ha Peru' THEN 'RAINFOR - 1 ha Peru'
WHEN dataSourceName='SALVIAS:Pilon Lajas Treeplots Bolivia' THEN 'Pilon Lajas Treeplots Bolivia'
WHEN dataSourceName='SALVIAS:Gentry Transect Dataset' THEN 'Gentry Transect Dataset'
WHEN dataSourceName='SALVIAS:ACA Amazon Forest Inventories' THEN 'ACA Amazon Forest Inventories'
ELSE dataSourceName
END
;

ALTER TABLE plot_metadata ALTER COLUMN plot_area_ha TYPE DECIMAL(7,3);
ALTER TABLE plot_metadata ALTER COLUMN stem_diam_min TYPE DECIMAL(7,3);
ALTER TABLE plot_metadata ALTER COLUMN stem_diam_max TYPE DECIMAL(7,3);

UPDATE plot_metadata AS a
SET
plot_area_ha=CAST(b.plotareaha AS DECIMAL(4,3)),
sampling_protocol='',
stem_diam_min=CAST(b.plotmindbh AS DECIMAL(7,3)),
stem_diam_min_units='cm'
FROM metadata_bien2 AS b
WHERE a.dataSource='SALVIAS'
AND a.dataset=b.dataSourceName
AND a.plot_name=b.plotcode
;

UPDATE plot_metadata
SET sampling_protocol='1 ha tree plot, stems >= 10 cm dbh'
WHERE datasource='SALVIAS' AND dataset='RAINFOR - 1 ha Peru'
;

UPDATE plot_metadata AS a
SET
abundance_measurement='individuals'
WHERE a.dataSource='SALVIAS'
;

UPDATE plot_metadata AS a
SET
abundance_measurement='cover'
WHERE a.dataSource='SALVIAS'
AND a.dataset IN (
'Noel Kempff Savanna Plots'
) 
;

UPDATE plot_metadata AS a
SET
growth_forms_included_trees='Yes',
growth_forms_included_shrubs='Yes',
growth_forms_included_lianas='Yes',
growth_forms_included_herbs='No',
growth_forms_included_epiphytes='No',
growth_forms_included_notes='Growths forms included determined by stem size cutoff/. Wody epiphtyes and both woody and herbaceous epiphytes included if stem or aerial root diameters >= min stem diameter at breast height',
taxa_included_seed_plants='Yes',
taxa_included_ferns_lycophytes='Yes',
taxa_included_bryophytes='No',
taxa_included_exclusions='Taxa included determined by stem size cutoff. May include tree ferns if stem diameter >= min stem diameter at breast height'
WHERE a.dataSource='SALVIAS'
AND a.dataset IN (
'Bonifacino Forest Transects',
'RAINFOR - 0.1 ha Madre de Dios, Peru',
'La Selva Secondary Forest Plots',
'Brad Boyle Forest Transects',
'Gentry Transect Dataset',
'OTS Transects'
) 
;



