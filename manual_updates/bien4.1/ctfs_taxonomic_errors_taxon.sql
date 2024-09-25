-- -----------------------------------------------------------------
-- Fixes taxonomic spelling errors found by Rick Condit. 
-- For BIEN 4.1
-- Strip all indexes from major tables before executing or this will 
-- be impossibly slow
-- Column "species" MUST be changed last!
-- -----------------------------------------------------------------

SET search_path TO analytical_db_dev;

--
-- Create required indexes
-- 

DROP INDEX IF EXISTS taxon_species_ctfs_idx;

CREATE INDEX taxon_species_ctfs_idx 
ON taxon (species)
WHERE species IN ('Annona billbergiana','Ardisia guyanensis','Ardisia knappii','Bactris coloradensis','Citharexylum micradenium','Coussarea curvigemma','Crataeva tapia','Cryosophila bartlettii','Mosannona garwoodiae','Myrsine pellucido-punctata','Prestoea longipetiolata','Psychotria graciflora','Wettinia equalis','Xilopia aromatica','Schinus terebinthifolius','Geonoma longivaginata')
;

--
-- Execute updates
--

UPDATE taxon
SET genus=
CASE
WHEN species='Annona billbergiana' THEN 'Annona'
WHEN species='Ardisia guyanensis' THEN 'Ardisia'
WHEN species='Ardisia knappii' THEN 'Ardisia'
WHEN species='Bactris coloradensis' THEN 'Bactris'
WHEN species='Citharexylum micradenium' THEN 'Citharexylum'
WHEN species='Coussarea curvigemma' THEN 'Coussarea'
WHEN species='Crataeva tapia' THEN 'Crateva'
WHEN species='Cryosophila bartlettii' THEN 'Cryosophila'
WHEN species='Mosannona garwoodiae' THEN 'Mosannona'
WHEN species='Myrsine pellucido-punctata' THEN 'Myrsine'
WHEN species='Prestoea longipetiolata' THEN 'Prestoea'
WHEN species='Psychotria graciflora' THEN 'Psychotria'
WHEN species='Wettinia equalis' THEN 'Wettinia'
WHEN species='Xilopia aromatica' THEN 'Xylopia'
WHEN species='Schinus terebinthifolius' THEN 'Schinus'
WHEN species='Geonoma longivaginata' THEN 'Geonoma'
ELSE genus
END
WHERE species IN ('Annona billbergiana','Ardisia guyanensis','Ardisia knappii','Bactris coloradensis','Citharexylum micradenium','Coussarea curvigemma','Crataeva tapia','Cryosophila bartlettii','Mosannona garwoodiae','Myrsine pellucido-punctata','Prestoea longipetiolata','Psychotria graciflora','Wettinia equalis','Xilopia aromatica','Schinus terebinthifolius','Geonoma longivaginata')
;

UPDATE taxon
SET taxon=
CASE
WHEN species='Annona billbergiana' THEN REPLACE(taxon,'Annona billbergiana','Annona billbergii')
WHEN species='Ardisia guyanensis' THEN REPLACE(taxon,'Ardisia guyanensis','Ardisia guianensis')
WHEN species='Ardisia knappii' THEN REPLACE(taxon,'Ardisia knappii','Ardisia knappiae')
WHEN species='Bactris coloradensis' THEN REPLACE(taxon,'Bactris coloradensis','Bactris coloradonis')
WHEN species='Citharexylum micradenium' THEN REPLACE(taxon,'Citharexylum micradenium','Citharexylum macradenium')
WHEN species='Coussarea curvigemma' THEN REPLACE(taxon,'Coussarea curvigemma','Coussarea curvigemmia')
WHEN species='Crataeva tapia' THEN REPLACE(taxon,'Crataeva tapia','Crateva tapia')
WHEN species='Cryosophila bartlettii' THEN REPLACE(taxon,'Cryosophila bartlettii','Cryosophila bartletii')
WHEN species='Mosannona garwoodiae' THEN REPLACE(taxon,'Mosannona garwoodiae','Mosannona garwoodii')
WHEN species='Myrsine pellucido-punctata' THEN REPLACE(taxon,'Myrsine pellucido-punctata','Myrsine pellucidopunctata')
WHEN species='Prestoea longipetiolata' THEN REPLACE(taxon,'Prestoea longipetiolata','Prestoea longepetiolata')
WHEN species='Psychotria graciflora' THEN REPLACE(taxon,'Psychotria graciflora','Psychotria graciliflora')
WHEN species='Wettinia equalis' THEN REPLACE(taxon,'Wettinia equalis','Wettinia aequalis')
WHEN species='Xilopia aromatica' THEN REPLACE(taxon,'Xilopia aromatica','Xylopia aromatica')
WHEN species='Schinus terebinthifolius' THEN REPLACE(taxon,'Schinus terebinthifolius','Schinus terebinthifolia')
WHEN species='Geonoma longivaginata' THEN REPLACE(taxon,'Geonoma longivaginata','Geonoma longevaginata')
ELSE taxon
END
WHERE species IN ('Annona billbergiana','Ardisia guyanensis','Ardisia knappii','Bactris coloradensis','Citharexylum micradenium','Coussarea curvigemma','Crataeva tapia','Cryosophila bartlettii','Mosannona garwoodiae','Myrsine pellucido-punctata','Prestoea longipetiolata','Psychotria graciflora','Wettinia equalis','Xilopia aromatica','Schinus terebinthifolius','Geonoma longivaginata')
;

UPDATE taxon
SET species=
CASE
WHEN species='Annona billbergiana' THEN 'Annona billbergii'
WHEN species='Ardisia guyanensis' THEN 'Ardisia guianensis'
WHEN species='Ardisia knappii' THEN 'Ardisia knappiae'
WHEN species='Bactris coloradensis' THEN 'Bactris coloradonis'
WHEN species='Citharexylum micradenium' THEN 'Citharexylum macradenium'
WHEN species='Coussarea curvigemma' THEN 'Coussarea curvigemmia'
WHEN species='Crataeva tapia' THEN 'Crateva tapia'
WHEN species='Cryosophila bartlettii' THEN 'Cryosophila bartletii'
WHEN species='Mosannona garwoodiae' THEN 'Mosannona garwoodii'
WHEN species='Myrsine pellucido-punctata' THEN 'Myrsine pellucidopunctata'
WHEN species='Prestoea longipetiolata' THEN 'Prestoea longepetiolata'
WHEN species='Psychotria graciflora' THEN 'Psychotria graciliflora'
WHEN species='Wettinia equalis' THEN 'Wettinia aequalis'
WHEN species='Xilopia aromatica' THEN 'Xylopia aromatica'
WHEN species='Schinus terebinthifolius' THEN 'Schinus terebinthifolia'
WHEN species='Geonoma longivaginata' THEN 'Geonoma longevaginata'
ELSE species
END
WHERE species IN ('Annona billbergiana','Ardisia guyanensis','Ardisia knappii','Bactris coloradensis','Citharexylum micradenium','Coussarea curvigemma','Crataeva tapia','Cryosophila bartlettii','Mosannona garwoodiae','Myrsine pellucido-punctata','Prestoea longipetiolata','Psychotria graciflora','Wettinia equalis','Xilopia aromatica','Schinus terebinthifolius','Geonoma longivaginata')
;

--
-- Drop indexes
-- 
DROP INDEX IF EXISTS taxon_species_ctfs_idx;
