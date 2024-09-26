-- -----------------------------------------------------------------
-- Fixes taxonomic spelling errors found by Rick Condit. 
-- For BIEN 4.1
-- Strip all indexes from major tables before executing or this will 
-- be impossibly slow
-- -----------------------------------------------------------------

SET search_path TO analytical_db_dev;

--
-- Create required indexes
-- 

DROP INDEX IF EXISTS agg_traits_scrubbed_species_binomial_ctfs_idx;

CREATE INDEX agg_traits_scrubbed_species_binomial_ctfs_idx 
ON agg_traits (scrubbed_species_binomial)
WHERE scrubbed_species_binomial IN ('Annona billbergiana','Ardisia guyanensis','Ardisia knappii','Bactris coloradensis','Citharexylum micradenium','Coussarea curvigemma','Crataeva tapia','Cryosophila bartlettii','Mosannona garwoodiae','Myrsine pellucido-punctata','Prestoea longipetiolata','Psychotria graciflora','Wettinia equalis','Xilopia aromatica','Schinus terebinthifolius','Geonoma longivaginata')
;

--
-- Execute updates
--

UPDATE agg_traits
SET scrubbed_genus=
CASE
WHEN scrubbed_species_binomial='Annona billbergiana' THEN 'Annona'
WHEN scrubbed_species_binomial='Ardisia guyanensis' THEN 'Ardisia'
WHEN scrubbed_species_binomial='Ardisia knappii' THEN 'Ardisia'
WHEN scrubbed_species_binomial='Bactris coloradensis' THEN 'Bactris'
WHEN scrubbed_species_binomial='Citharexylum micradenium' THEN 'Citharexylum'
WHEN scrubbed_species_binomial='Coussarea curvigemma' THEN 'Coussarea'
WHEN scrubbed_species_binomial='Crataeva tapia' THEN 'Crateva'
WHEN scrubbed_species_binomial='Cryosophila bartlettii' THEN 'Cryosophila'
WHEN scrubbed_species_binomial='Mosannona garwoodiae' THEN 'Mosannona'
WHEN scrubbed_species_binomial='Myrsine pellucido-punctata' THEN 'Myrsine'
WHEN scrubbed_species_binomial='Prestoea longipetiolata' THEN 'Prestoea'
WHEN scrubbed_species_binomial='Psychotria graciflora' THEN 'Psychotria'
WHEN scrubbed_species_binomial='Wettinia equalis' THEN 'Wettinia'
WHEN scrubbed_species_binomial='Xilopia aromatica' THEN 'Xylopia'
WHEN scrubbed_species_binomial='Schinus terebinthifolius' THEN 'Schinus'
WHEN scrubbed_species_binomial='Geonoma longivaginata' THEN 'Geonoma'
ELSE scrubbed_genus
END
WHERE scrubbed_species_binomial IN ('Annona billbergiana','Ardisia guyanensis','Ardisia knappii','Bactris coloradensis','Citharexylum micradenium','Coussarea curvigemma','Crataeva tapia','Cryosophila bartlettii','Mosannona garwoodiae','Myrsine pellucido-punctata','Prestoea longipetiolata','Psychotria graciflora','Wettinia equalis','Xilopia aromatica','Schinus terebinthifolius','Geonoma longivaginata')
;

UPDATE agg_traits
SET scrubbed_specific_epithet=
CASE
WHEN scrubbed_species_binomial='Annona billbergiana' THEN 'billbergii'
WHEN scrubbed_species_binomial='Ardisia guyanensis' THEN 'guianensis'
WHEN scrubbed_species_binomial='Ardisia knappii' THEN 'knappiae'
WHEN scrubbed_species_binomial='Bactris coloradensis' THEN 'coloradonis'
WHEN scrubbed_species_binomial='Citharexylum micradenium' THEN 'macradenium'
WHEN scrubbed_species_binomial='Coussarea curvigemma' THEN 'curvigemmia'
WHEN scrubbed_species_binomial='Crataeva tapia' THEN 'tapia'
WHEN scrubbed_species_binomial='Cryosophila bartlettii' THEN 'bartletii'
WHEN scrubbed_species_binomial='Mosannona garwoodiae' THEN 'garwoodii'
WHEN scrubbed_species_binomial='Myrsine pellucido-punctata' THEN 'pellucidopunctata'
WHEN scrubbed_species_binomial='Prestoea longipetiolata' THEN 'longepetiolata'
WHEN scrubbed_species_binomial='Psychotria graciflora' THEN 'graciliflora'
WHEN scrubbed_species_binomial='Wettinia equalis' THEN 'aequalis'
WHEN scrubbed_species_binomial='Xilopia aromatica' THEN 'aromatica'
WHEN scrubbed_species_binomial='Schinus terebinthifolius' THEN 'terebinthifolia'
WHEN scrubbed_species_binomial='Geonoma longivaginata' THEN 'longevaginata'
ELSE scrubbed_specific_epithet
END
WHERE scrubbed_species_binomial IN ('Annona billbergiana','Ardisia guyanensis','Ardisia knappii','Bactris coloradensis','Citharexylum micradenium','Coussarea curvigemma','Crataeva tapia','Cryosophila bartlettii','Mosannona garwoodiae','Myrsine pellucido-punctata','Prestoea longipetiolata','Psychotria graciflora','Wettinia equalis','Xilopia aromatica','Schinus terebinthifolius','Geonoma longivaginata')
;

UPDATE agg_traits
SET scrubbed_taxon_name_no_author=
CASE
WHEN scrubbed_species_binomial='Annona billbergiana' THEN 'Annona billbergii'
WHEN scrubbed_species_binomial='Ardisia guyanensis' THEN 'Ardisia guianensis'
WHEN scrubbed_species_binomial='Ardisia knappii' THEN 'Ardisia knappiae'
WHEN scrubbed_species_binomial='Bactris coloradensis' THEN 'Bactris coloradonis'
WHEN scrubbed_species_binomial='Citharexylum micradenium' THEN 'Citharexylum macradenium'
WHEN scrubbed_species_binomial='Coussarea curvigemma' THEN 'Coussarea curvigemmia'
WHEN scrubbed_species_binomial='Crataeva tapia' THEN 'Crateva tapia'
WHEN scrubbed_species_binomial='Cryosophila bartlettii' THEN 'Cryosophila bartletii'
WHEN scrubbed_species_binomial='Mosannona garwoodiae' THEN 'Mosannona garwoodii'
WHEN scrubbed_species_binomial='Myrsine pellucido-punctata' THEN 'Myrsine pellucidopunctata'
WHEN scrubbed_species_binomial='Prestoea longipetiolata' THEN 'Prestoea longepetiolata'
WHEN scrubbed_species_binomial='Psychotria graciflora' THEN 'Psychotria graciliflora'
WHEN scrubbed_species_binomial='Wettinia equalis' THEN 'Wettinia aequalis'
WHEN scrubbed_species_binomial='Xilopia aromatica' THEN 'Xylopia aromatica'
WHEN scrubbed_species_binomial='Schinus terebinthifolius' THEN 'Schinus terebinthifolia'
WHEN scrubbed_species_binomial='Geonoma longivaginata' THEN 'Geonoma longevaginata'
ELSE scrubbed_taxon_name_no_author
END
WHERE scrubbed_species_binomial IN ('Annona billbergiana','Ardisia guyanensis','Ardisia knappii','Bactris coloradensis','Citharexylum micradenium','Coussarea curvigemma','Crataeva tapia','Cryosophila bartlettii','Mosannona garwoodiae','Myrsine pellucido-punctata','Prestoea longipetiolata','Psychotria graciflora','Wettinia equalis','Xilopia aromatica','Schinus terebinthifolius','Geonoma longivaginata')
;

UPDATE agg_traits
SET scrubbed_taxon_canonical=
CASE
WHEN scrubbed_species_binomial='Annona billbergiana' THEN 'Annona billbergii'
WHEN scrubbed_species_binomial='Ardisia guyanensis' THEN 'Ardisia guianensis'
WHEN scrubbed_species_binomial='Ardisia knappii' THEN 'Ardisia knappiae'
WHEN scrubbed_species_binomial='Bactris coloradensis' THEN 'Bactris coloradonis'
WHEN scrubbed_species_binomial='Citharexylum micradenium' THEN 'Citharexylum macradenium'
WHEN scrubbed_species_binomial='Coussarea curvigemma' THEN 'Coussarea curvigemmia'
WHEN scrubbed_species_binomial='Crataeva tapia' THEN 'Crateva tapia'
WHEN scrubbed_species_binomial='Cryosophila bartlettii' THEN 'Cryosophila bartletii'
WHEN scrubbed_species_binomial='Mosannona garwoodiae' THEN 'Mosannona garwoodii'
WHEN scrubbed_species_binomial='Myrsine pellucido-punctata' THEN 'Myrsine pellucidopunctata'
WHEN scrubbed_species_binomial='Prestoea longipetiolata' THEN 'Prestoea longepetiolata'
WHEN scrubbed_species_binomial='Psychotria graciflora' THEN 'Psychotria graciliflora'
WHEN scrubbed_species_binomial='Wettinia equalis' THEN 'Wettinia aequalis'
WHEN scrubbed_species_binomial='Xilopia aromatica' THEN 'Xylopia aromatica'
WHEN scrubbed_species_binomial='Schinus terebinthifolius' THEN 'Schinus terebinthifolia'
WHEN scrubbed_species_binomial='Geonoma longivaginata' THEN 'Geonoma longevaginata'
ELSE scrubbed_taxon_canonical
END
WHERE scrubbed_species_binomial IN ('Annona billbergiana','Ardisia guyanensis','Ardisia knappii','Bactris coloradensis','Citharexylum micradenium','Coussarea curvigemma','Crataeva tapia','Cryosophila bartlettii','Mosannona garwoodiae','Myrsine pellucido-punctata','Prestoea longipetiolata','Psychotria graciflora','Wettinia equalis','Xilopia aromatica','Schinus terebinthifolius','Geonoma longivaginata')
;

UPDATE agg_traits
SET scrubbed_taxon_name_with_author=
CASE
WHEN scrubbed_species_binomial='Annona billbergiana' THEN CONCAT_WS(' ', 'Annona billbergii', COALESCE(scrubbed_author,''))
WHEN scrubbed_species_binomial='Ardisia guyanensis' THEN CONCAT_WS(' ', 'Ardisia guianensis', COALESCE(scrubbed_author,''))
WHEN scrubbed_species_binomial='Ardisia knappii' THEN CONCAT_WS(' ', 'Ardisia knappiae', COALESCE(scrubbed_author,''))
WHEN scrubbed_species_binomial='Bactris coloradensis' THEN CONCAT_WS(' ', 'Bactris coloradonis', COALESCE(scrubbed_author,''))
WHEN scrubbed_species_binomial='Citharexylum micradenium' THEN CONCAT_WS(' ', 'Citharexylum macradenium', COALESCE(scrubbed_author,''))
WHEN scrubbed_species_binomial='Coussarea curvigemma' THEN CONCAT_WS(' ', 'Coussarea curvigemmia', COALESCE(scrubbed_author,''))
WHEN scrubbed_species_binomial='Crataeva tapia' THEN CONCAT_WS(' ', 'Crateva tapia', COALESCE(scrubbed_author,''))
WHEN scrubbed_species_binomial='Cryosophila bartlettii' THEN CONCAT_WS(' ', 'Cryosophila bartletii', COALESCE(scrubbed_author,''))
WHEN scrubbed_species_binomial='Mosannona garwoodiae' THEN CONCAT_WS(' ', 'Mosannona garwoodii', COALESCE(scrubbed_author,''))
WHEN scrubbed_species_binomial='Myrsine pellucido-punctata' THEN CONCAT_WS(' ', 'Myrsine pellucidopunctata', COALESCE(scrubbed_author,''))
WHEN scrubbed_species_binomial='Prestoea longipetiolata' THEN CONCAT_WS(' ', 'Prestoea longepetiolata', COALESCE(scrubbed_author,''))
WHEN scrubbed_species_binomial='Psychotria graciflora' THEN CONCAT_WS(' ', 'Psychotria graciliflora', COALESCE(scrubbed_author,''))
WHEN scrubbed_species_binomial='Wettinia equalis' THEN CONCAT_WS(' ', 'Wettinia aequalis', COALESCE(scrubbed_author,''))
WHEN scrubbed_species_binomial='Xilopia aromatica' THEN CONCAT_WS(' ', 'Xylopia aromatica', COALESCE(scrubbed_author,''))
WHEN scrubbed_species_binomial='Schinus terebinthifolius' THEN CONCAT_WS(' ', 'Schinus terebinthifolia', COALESCE(scrubbed_author,''))
WHEN scrubbed_species_binomial='Geonoma longivaginata' THEN CONCAT_WS(' ', 'Geonoma longevaginata', COALESCE(scrubbed_author,''))
ELSE scrubbed_taxon_name_with_author
END
WHERE scrubbed_species_binomial IN ('Annona billbergiana','Ardisia guyanensis','Ardisia knappii','Bactris coloradensis','Citharexylum micradenium','Coussarea curvigemma','Crataeva tapia','Cryosophila bartlettii','Mosannona garwoodiae','Myrsine pellucido-punctata','Prestoea longipetiolata','Psychotria graciflora','Wettinia equalis','Xilopia aromatica','Schinus terebinthifolius','Geonoma longivaginata')
;

UPDATE agg_traits
SET scrubbed_species_binomial_with_morphospecies=
CASE
WHEN scrubbed_species_binomial='Annona billbergiana' THEN 'Annona billbergii'
WHEN scrubbed_species_binomial='Ardisia guyanensis' THEN 'Ardisia guianensis'
WHEN scrubbed_species_binomial='Ardisia knappii' THEN 'Ardisia knappiae'
WHEN scrubbed_species_binomial='Bactris coloradensis' THEN 'Bactris coloradonis'
WHEN scrubbed_species_binomial='Citharexylum micradenium' THEN 'Citharexylum macradenium'
WHEN scrubbed_species_binomial='Coussarea curvigemma' THEN 'Coussarea curvigemmia'
WHEN scrubbed_species_binomial='Crataeva tapia' THEN 'Crateva tapia'
WHEN scrubbed_species_binomial='Cryosophila bartlettii' THEN 'Cryosophila bartletii'
WHEN scrubbed_species_binomial='Mosannona garwoodiae' THEN 'Mosannona garwoodii'
WHEN scrubbed_species_binomial='Myrsine pellucido-punctata' THEN 'Myrsine pellucidopunctata'
WHEN scrubbed_species_binomial='Prestoea longipetiolata' THEN 'Prestoea longepetiolata'
WHEN scrubbed_species_binomial='Psychotria graciflora' THEN 'Psychotria graciliflora'
WHEN scrubbed_species_binomial='Wettinia equalis' THEN 'Wettinia aequalis'
WHEN scrubbed_species_binomial='Xilopia aromatica' THEN 'Xylopia aromatica'
WHEN scrubbed_species_binomial='Schinus terebinthifolius' THEN 'Schinus terebinthifolia'
WHEN scrubbed_species_binomial='Geonoma longivaginata' THEN 'Geonoma longevaginata'
ELSE scrubbed_species_binomial_with_morphospecies
END
WHERE scrubbed_species_binomial IN ('Annona billbergiana','Ardisia guyanensis','Ardisia knappii','Bactris coloradensis','Citharexylum micradenium','Coussarea curvigemma','Crataeva tapia','Cryosophila bartlettii','Mosannona garwoodiae','Myrsine pellucido-punctata','Prestoea longipetiolata','Psychotria graciflora','Wettinia equalis','Xilopia aromatica','Schinus terebinthifolius','Geonoma longivaginata')
;

UPDATE agg_traits
SET scrubbed_species_binomial=
CASE
WHEN scrubbed_species_binomial='Annona billbergiana' THEN 'Annona billbergii'
WHEN scrubbed_species_binomial='Ardisia guyanensis' THEN 'Ardisia guianensis'
WHEN scrubbed_species_binomial='Ardisia knappii' THEN 'Ardisia knappiae'
WHEN scrubbed_species_binomial='Bactris coloradensis' THEN 'Bactris coloradonis'
WHEN scrubbed_species_binomial='Citharexylum micradenium' THEN 'Citharexylum macradenium'
WHEN scrubbed_species_binomial='Coussarea curvigemma' THEN 'Coussarea curvigemmia'
WHEN scrubbed_species_binomial='Crataeva tapia' THEN 'Crateva tapia'
WHEN scrubbed_species_binomial='Cryosophila bartlettii' THEN 'Cryosophila bartletii'
WHEN scrubbed_species_binomial='Mosannona garwoodiae' THEN 'Mosannona garwoodii'
WHEN scrubbed_species_binomial='Myrsine pellucido-punctata' THEN 'Myrsine pellucidopunctata'
WHEN scrubbed_species_binomial='Prestoea longipetiolata' THEN 'Prestoea longepetiolata'
WHEN scrubbed_species_binomial='Psychotria graciflora' THEN 'Psychotria graciliflora'
WHEN scrubbed_species_binomial='Wettinia equalis' THEN 'Wettinia aequalis'
WHEN scrubbed_species_binomial='Xilopia aromatica' THEN 'Xylopia aromatica'
WHEN scrubbed_species_binomial='Schinus terebinthifolius' THEN 'Schinus terebinthifolia'
WHEN scrubbed_species_binomial='Geonoma longivaginata' THEN 'Geonoma longevaginata'
ELSE scrubbed_species_binomial
END
WHERE scrubbed_species_binomial IN ('Annona billbergiana','Ardisia guyanensis','Ardisia knappii','Bactris coloradensis','Citharexylum micradenium','Coussarea curvigemma','Crataeva tapia','Cryosophila bartlettii','Mosannona garwoodiae','Myrsine pellucido-punctata','Prestoea longipetiolata','Psychotria graciflora','Wettinia equalis','Xilopia aromatica','Schinus terebinthifolius','Geonoma longivaginata')
;

--
-- Drop indexes
-- 
DROP INDEX IF EXISTS agg_traits_scrubbed_species_binomial_ctfs_idx;
