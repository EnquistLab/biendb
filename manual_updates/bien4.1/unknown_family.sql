-- -----------------------------------------------------------------
-- Populates unknown or missing family, mostly caused by glitches in 
-- Tropicos. 
-- Fix for BIEN 4.1
-- Strip all indexes from major tables before executing or this will 
-- be impossibly slow
-- -----------------------------------------------------------------

SET search_path TO analytical_db_dev;

--
-- Create required indexes
-- 
DROP INDEX IF EXISTS vfoi_scrubbed_species_binomial_scrubbed_family_unknown_idx;
DROP INDEX IF EXISTS agg_traits_scrubbed_species_binomial_scrubbed_family_unknown_idx;
DROP INDEX IF EXISTS bien_taxonomy_scrubbed_species_binomial_scrubbed_family_unknown_idx;
DROP INDEX IF EXISTS taxon_species_family_unknown_idx;

CREATE INDEX vfoi_scrubbed_species_binomial_scrubbed_family_unknown_idx 
ON view_full_occurrence_individual (scrubbed_species_binomial)
WHERE scrubbed_family='Unknown' OR scrubbed_family IS NULL
;
CREATE INDEX agg_traits_scrubbed_species_binomial_scrubbed_family_unknown_idx 
ON agg_traits (scrubbed_species_binomial)
WHERE scrubbed_family='Unknown' OR scrubbed_family IS NULL
;
CREATE INDEX bien_taxonomy_scrubbed_species_binomial_scrubbed_family_unknown_idx 
ON bien_taxonomy (scrubbed_species_binomial)
WHERE scrubbed_family='Unknown' OR scrubbed_family IS NULL
;
CREATE INDEX taxon_species_family_unknown_idx 
ON taxon (species)
WHERE family='Unknown' OR family IS NULL
;

-- 
-- Update tables
---
UPDATE view_full_occurrence_individual
SET scrubbed_family=
CASE
WHEN scrubbed_species_binomial='Ruellia caroliniensis' THEN 'Acanthaceae'
WHEN scrubbed_species_binomial='Heteromorpha gossweileri' THEN 'Apiaceae'
WHEN scrubbed_species_binomial='Aristolochia longa' THEN 'Aristolochiaceae'
WHEN scrubbed_species_binomial='Artemisia campestris' THEN 'Asteraceae'
WHEN scrubbed_species_binomial='Ericameria nauseosa' THEN 'Asteraceae'
WHEN scrubbed_species_binomial='Erigeron peregrinus' THEN 'Asteraceae'
WHEN scrubbed_species_binomial='Senecio varicosus' THEN 'Asteraceae'
WHEN scrubbed_species_binomial='Solidago simplex' THEN 'Asteraceae'
WHEN scrubbed_species_binomial='Symphyotrichum lanceolatum' THEN 'Asteraceae'
WHEN scrubbed_species_binomial='Camelina sativa' THEN 'Brassicaceae'
WHEN scrubbed_species_binomial='Capsella bursa-pastoris' THEN 'Brassicaceae'
WHEN scrubbed_species_binomial='Campanula velutina' THEN 'Campanulaceae'
WHEN scrubbed_species_binomial='Cephaloziella varians' THEN 'Cephaloziellaceae'
WHEN scrubbed_species_binomial='Carex cristata' THEN 'Cyperaceae'
WHEN scrubbed_species_binomial='Carex glauca' THEN 'Cyperaceae'
WHEN scrubbed_species_binomial='Carex oederi' THEN 'Cyperaceae'
WHEN scrubbed_species_binomial='Carex ovalis' THEN 'Cyperaceae'
WHEN scrubbed_species_binomial='Carex viridula' THEN 'Cyperaceae'
WHEN scrubbed_species_binomial='Ephedra vulgaris' THEN 'Ephedraceae'
WHEN scrubbed_species_binomial='Vaccinium cubense' THEN 'Ericaceae'
WHEN scrubbed_species_binomial='Acacia discolor' THEN 'Fabaceae'
WHEN scrubbed_species_binomial='Astragalus boissieri' THEN 'Fabaceae'
WHEN scrubbed_species_binomial='Astragalus tragacanthoides' THEN 'Fabaceae'
WHEN scrubbed_species_binomial='Chamaecrista nictitans' THEN 'Fabaceae'
WHEN scrubbed_species_binomial='Coelidium villosum' THEN 'Fabaceae'
WHEN scrubbed_species_binomial='Dorycnium pentaphyllum' THEN 'Fabaceae'
WHEN scrubbed_species_binomial='Emerus major' THEN 'Fabaceae'
WHEN scrubbed_species_binomial='Hippocrepis scabra' THEN 'Fabaceae'
WHEN scrubbed_species_binomial='Lupinus argenteus' THEN 'Fabaceae'
WHEN scrubbed_species_binomial='Lupinus sellulus' THEN 'Fabaceae'
WHEN scrubbed_species_binomial='Centaurium minus' THEN 'Gentianaceae'
WHEN scrubbed_species_binomial='Gentiana germanica' THEN 'Gentianaceae'
WHEN scrubbed_species_binomial='Cyrtandra kealiae' THEN 'Gesneriaceae'
WHEN scrubbed_species_binomial='Rhytidophyllum auriculatum' THEN 'Gesneriaceae'
WHEN scrubbed_species_binomial='Jubula hutchinsiae' THEN 'Jubulaceae'
WHEN scrubbed_species_binomial='Solenostoma cryptogynum' THEN 'Jungermanniaceae'
WHEN scrubbed_species_binomial='Calamintha nepeta' THEN 'Lamiaceae'
WHEN scrubbed_species_binomial='Monarda citriodora' THEN 'Lamiaceae'
WHEN scrubbed_species_binomial='Salvia dorrii' THEN 'Lamiaceae'
WHEN scrubbed_species_binomial='Salvia formosana' THEN 'Lamiaceae'
WHEN scrubbed_species_binomial='Eucalyptus umbellata' THEN 'Myrtaceae'
WHEN scrubbed_species_binomial='Eugenia glazioviana' THEN 'Myrtaceae'
WHEN scrubbed_species_binomial='Melaleuca parviflora' THEN 'Myrtaceae'
WHEN scrubbed_species_binomial='Ophrys oestrifera' THEN 'Orchidaceae'
WHEN scrubbed_species_binomial='Orchis tridentata' THEN 'Orchidaceae'
WHEN scrubbed_species_binomial='Hedyotis auricularia' THEN 'Rubiaceae'
WHEN scrubbed_species_binomial='Hedyotis caerulea' THEN 'Rubiaceae'
WHEN scrubbed_species_binomial='Hedyotis corymbosa' THEN 'Rubiaceae'
WHEN scrubbed_species_binomial='Psychotria salicifolia' THEN 'Rubiaceae'
WHEN scrubbed_species_binomial='Psychotria sessilis' THEN 'Rubiaceae'
WHEN scrubbed_species_binomial='Salix glauca' THEN 'Salicaceae'
WHEN scrubbed_species_binomial='Rhoicissus tridentata' THEN 'Vitaceae'
ELSE scrubbed_family
END
WHERE scrubbed_family='Unknown' OR scrubbed_family IS NULL
;

UPDATE agg_traits
SET scrubbed_family=
CASE
WHEN scrubbed_species_binomial='Ruellia caroliniensis' THEN 'Acanthaceae'
WHEN scrubbed_species_binomial='Heteromorpha gossweileri' THEN 'Apiaceae'
WHEN scrubbed_species_binomial='Aristolochia longa' THEN 'Aristolochiaceae'
WHEN scrubbed_species_binomial='Artemisia campestris' THEN 'Asteraceae'
WHEN scrubbed_species_binomial='Ericameria nauseosa' THEN 'Asteraceae'
WHEN scrubbed_species_binomial='Erigeron peregrinus' THEN 'Asteraceae'
WHEN scrubbed_species_binomial='Senecio varicosus' THEN 'Asteraceae'
WHEN scrubbed_species_binomial='Solidago simplex' THEN 'Asteraceae'
WHEN scrubbed_species_binomial='Symphyotrichum lanceolatum' THEN 'Asteraceae'
WHEN scrubbed_species_binomial='Camelina sativa' THEN 'Brassicaceae'
WHEN scrubbed_species_binomial='Capsella bursa-pastoris' THEN 'Brassicaceae'
WHEN scrubbed_species_binomial='Campanula velutina' THEN 'Campanulaceae'
WHEN scrubbed_species_binomial='Cephaloziella varians' THEN 'Cephaloziellaceae'
WHEN scrubbed_species_binomial='Carex cristata' THEN 'Cyperaceae'
WHEN scrubbed_species_binomial='Carex glauca' THEN 'Cyperaceae'
WHEN scrubbed_species_binomial='Carex oederi' THEN 'Cyperaceae'
WHEN scrubbed_species_binomial='Carex ovalis' THEN 'Cyperaceae'
WHEN scrubbed_species_binomial='Carex viridula' THEN 'Cyperaceae'
WHEN scrubbed_species_binomial='Ephedra vulgaris' THEN 'Ephedraceae'
WHEN scrubbed_species_binomial='Vaccinium cubense' THEN 'Ericaceae'
WHEN scrubbed_species_binomial='Acacia discolor' THEN 'Fabaceae'
WHEN scrubbed_species_binomial='Astragalus boissieri' THEN 'Fabaceae'
WHEN scrubbed_species_binomial='Astragalus tragacanthoides' THEN 'Fabaceae'
WHEN scrubbed_species_binomial='Chamaecrista nictitans' THEN 'Fabaceae'
WHEN scrubbed_species_binomial='Coelidium villosum' THEN 'Fabaceae'
WHEN scrubbed_species_binomial='Dorycnium pentaphyllum' THEN 'Fabaceae'
WHEN scrubbed_species_binomial='Emerus major' THEN 'Fabaceae'
WHEN scrubbed_species_binomial='Hippocrepis scabra' THEN 'Fabaceae'
WHEN scrubbed_species_binomial='Lupinus argenteus' THEN 'Fabaceae'
WHEN scrubbed_species_binomial='Lupinus sellulus' THEN 'Fabaceae'
WHEN scrubbed_species_binomial='Centaurium minus' THEN 'Gentianaceae'
WHEN scrubbed_species_binomial='Gentiana germanica' THEN 'Gentianaceae'
WHEN scrubbed_species_binomial='Cyrtandra kealiae' THEN 'Gesneriaceae'
WHEN scrubbed_species_binomial='Rhytidophyllum auriculatum' THEN 'Gesneriaceae'
WHEN scrubbed_species_binomial='Jubula hutchinsiae' THEN 'Jubulaceae'
WHEN scrubbed_species_binomial='Solenostoma cryptogynum' THEN 'Jungermanniaceae'
WHEN scrubbed_species_binomial='Calamintha nepeta' THEN 'Lamiaceae'
WHEN scrubbed_species_binomial='Monarda citriodora' THEN 'Lamiaceae'
WHEN scrubbed_species_binomial='Salvia dorrii' THEN 'Lamiaceae'
WHEN scrubbed_species_binomial='Salvia formosana' THEN 'Lamiaceae'
WHEN scrubbed_species_binomial='Eucalyptus umbellata' THEN 'Myrtaceae'
WHEN scrubbed_species_binomial='Eugenia glazioviana' THEN 'Myrtaceae'
WHEN scrubbed_species_binomial='Melaleuca parviflora' THEN 'Myrtaceae'
WHEN scrubbed_species_binomial='Ophrys oestrifera' THEN 'Orchidaceae'
WHEN scrubbed_species_binomial='Orchis tridentata' THEN 'Orchidaceae'
WHEN scrubbed_species_binomial='Hedyotis auricularia' THEN 'Rubiaceae'
WHEN scrubbed_species_binomial='Hedyotis caerulea' THEN 'Rubiaceae'
WHEN scrubbed_species_binomial='Hedyotis corymbosa' THEN 'Rubiaceae'
WHEN scrubbed_species_binomial='Psychotria salicifolia' THEN 'Rubiaceae'
WHEN scrubbed_species_binomial='Psychotria sessilis' THEN 'Rubiaceae'
WHEN scrubbed_species_binomial='Salix glauca' THEN 'Salicaceae'
WHEN scrubbed_species_binomial='Rhoicissus tridentata' THEN 'Vitaceae'
ELSE scrubbed_family
END
WHERE scrubbed_family='Unknown' OR scrubbed_family IS NULL
;

UPDATE bien_taxonomy
SET scrubbed_family=
CASE
WHEN scrubbed_species_binomial='Ruellia caroliniensis' THEN 'Acanthaceae'
WHEN scrubbed_species_binomial='Heteromorpha gossweileri' THEN 'Apiaceae'
WHEN scrubbed_species_binomial='Aristolochia longa' THEN 'Aristolochiaceae'
WHEN scrubbed_species_binomial='Artemisia campestris' THEN 'Asteraceae'
WHEN scrubbed_species_binomial='Ericameria nauseosa' THEN 'Asteraceae'
WHEN scrubbed_species_binomial='Erigeron peregrinus' THEN 'Asteraceae'
WHEN scrubbed_species_binomial='Senecio varicosus' THEN 'Asteraceae'
WHEN scrubbed_species_binomial='Solidago simplex' THEN 'Asteraceae'
WHEN scrubbed_species_binomial='Symphyotrichum lanceolatum' THEN 'Asteraceae'
WHEN scrubbed_species_binomial='Camelina sativa' THEN 'Brassicaceae'
WHEN scrubbed_species_binomial='Capsella bursa-pastoris' THEN 'Brassicaceae'
WHEN scrubbed_species_binomial='Campanula velutina' THEN 'Campanulaceae'
WHEN scrubbed_species_binomial='Cephaloziella varians' THEN 'Cephaloziellaceae'
WHEN scrubbed_species_binomial='Carex cristata' THEN 'Cyperaceae'
WHEN scrubbed_species_binomial='Carex glauca' THEN 'Cyperaceae'
WHEN scrubbed_species_binomial='Carex oederi' THEN 'Cyperaceae'
WHEN scrubbed_species_binomial='Carex ovalis' THEN 'Cyperaceae'
WHEN scrubbed_species_binomial='Carex viridula' THEN 'Cyperaceae'
WHEN scrubbed_species_binomial='Ephedra vulgaris' THEN 'Ephedraceae'
WHEN scrubbed_species_binomial='Vaccinium cubense' THEN 'Ericaceae'
WHEN scrubbed_species_binomial='Acacia discolor' THEN 'Fabaceae'
WHEN scrubbed_species_binomial='Astragalus boissieri' THEN 'Fabaceae'
WHEN scrubbed_species_binomial='Astragalus tragacanthoides' THEN 'Fabaceae'
WHEN scrubbed_species_binomial='Chamaecrista nictitans' THEN 'Fabaceae'
WHEN scrubbed_species_binomial='Coelidium villosum' THEN 'Fabaceae'
WHEN scrubbed_species_binomial='Dorycnium pentaphyllum' THEN 'Fabaceae'
WHEN scrubbed_species_binomial='Emerus major' THEN 'Fabaceae'
WHEN scrubbed_species_binomial='Hippocrepis scabra' THEN 'Fabaceae'
WHEN scrubbed_species_binomial='Lupinus argenteus' THEN 'Fabaceae'
WHEN scrubbed_species_binomial='Lupinus sellulus' THEN 'Fabaceae'
WHEN scrubbed_species_binomial='Centaurium minus' THEN 'Gentianaceae'
WHEN scrubbed_species_binomial='Gentiana germanica' THEN 'Gentianaceae'
WHEN scrubbed_species_binomial='Cyrtandra kealiae' THEN 'Gesneriaceae'
WHEN scrubbed_species_binomial='Rhytidophyllum auriculatum' THEN 'Gesneriaceae'
WHEN scrubbed_species_binomial='Jubula hutchinsiae' THEN 'Jubulaceae'
WHEN scrubbed_species_binomial='Solenostoma cryptogynum' THEN 'Jungermanniaceae'
WHEN scrubbed_species_binomial='Calamintha nepeta' THEN 'Lamiaceae'
WHEN scrubbed_species_binomial='Monarda citriodora' THEN 'Lamiaceae'
WHEN scrubbed_species_binomial='Salvia dorrii' THEN 'Lamiaceae'
WHEN scrubbed_species_binomial='Salvia formosana' THEN 'Lamiaceae'
WHEN scrubbed_species_binomial='Eucalyptus umbellata' THEN 'Myrtaceae'
WHEN scrubbed_species_binomial='Eugenia glazioviana' THEN 'Myrtaceae'
WHEN scrubbed_species_binomial='Melaleuca parviflora' THEN 'Myrtaceae'
WHEN scrubbed_species_binomial='Ophrys oestrifera' THEN 'Orchidaceae'
WHEN scrubbed_species_binomial='Orchis tridentata' THEN 'Orchidaceae'
WHEN scrubbed_species_binomial='Hedyotis auricularia' THEN 'Rubiaceae'
WHEN scrubbed_species_binomial='Hedyotis caerulea' THEN 'Rubiaceae'
WHEN scrubbed_species_binomial='Hedyotis corymbosa' THEN 'Rubiaceae'
WHEN scrubbed_species_binomial='Psychotria salicifolia' THEN 'Rubiaceae'
WHEN scrubbed_species_binomial='Psychotria sessilis' THEN 'Rubiaceae'
WHEN scrubbed_species_binomial='Salix glauca' THEN 'Salicaceae'
WHEN scrubbed_species_binomial='Rhoicissus tridentata' THEN 'Vitaceae'
ELSE scrubbed_family
END
WHERE scrubbed_family='Unknown' OR scrubbed_family IS NULL
;

UPDATE taxon
SET family=
CASE
WHEN species='Ruellia caroliniensis' THEN 'Acanthaceae'
WHEN species='Heteromorpha gossweileri' THEN 'Apiaceae'
WHEN species='Aristolochia longa' THEN 'Aristolochiaceae'
WHEN species='Artemisia campestris' THEN 'Asteraceae'
WHEN species='Ericameria nauseosa' THEN 'Asteraceae'
WHEN species='Erigeron peregrinus' THEN 'Asteraceae'
WHEN species='Senecio varicosus' THEN 'Asteraceae'
WHEN species='Solidago simplex' THEN 'Asteraceae'
WHEN species='Symphyotrichum lanceolatum' THEN 'Asteraceae'
WHEN species='Camelina sativa' THEN 'Brassicaceae'
WHEN species='Capsella bursa-pastoris' THEN 'Brassicaceae'
WHEN species='Campanula velutina' THEN 'Campanulaceae'
WHEN species='Cephaloziella varians' THEN 'Cephaloziellaceae'
WHEN species='Carex cristata' THEN 'Cyperaceae'
WHEN species='Carex glauca' THEN 'Cyperaceae'
WHEN species='Carex oederi' THEN 'Cyperaceae'
WHEN species='Carex ovalis' THEN 'Cyperaceae'
WHEN species='Carex viridula' THEN 'Cyperaceae'
WHEN species='Ephedra vulgaris' THEN 'Ephedraceae'
WHEN species='Vaccinium cubense' THEN 'Ericaceae'
WHEN species='Acacia discolor' THEN 'Fabaceae'
WHEN species='Astragalus boissieri' THEN 'Fabaceae'
WHEN species='Astragalus tragacanthoides' THEN 'Fabaceae'
WHEN species='Chamaecrista nictitans' THEN 'Fabaceae'
WHEN species='Coelidium villosum' THEN 'Fabaceae'
WHEN species='Dorycnium pentaphyllum' THEN 'Fabaceae'
WHEN species='Emerus major' THEN 'Fabaceae'
WHEN species='Hippocrepis scabra' THEN 'Fabaceae'
WHEN species='Lupinus argenteus' THEN 'Fabaceae'
WHEN species='Lupinus sellulus' THEN 'Fabaceae'
WHEN species='Centaurium minus' THEN 'Gentianaceae'
WHEN species='Gentiana germanica' THEN 'Gentianaceae'
WHEN species='Cyrtandra kealiae' THEN 'Gesneriaceae'
WHEN species='Rhytidophyllum auriculatum' THEN 'Gesneriaceae'
WHEN species='Jubula hutchinsiae' THEN 'Jubulaceae'
WHEN species='Solenostoma cryptogynum' THEN 'Jungermanniaceae'
WHEN species='Calamintha nepeta' THEN 'Lamiaceae'
WHEN species='Monarda citriodora' THEN 'Lamiaceae'
WHEN species='Salvia dorrii' THEN 'Lamiaceae'
WHEN species='Salvia formosana' THEN 'Lamiaceae'
WHEN species='Eucalyptus umbellata' THEN 'Myrtaceae'
WHEN species='Eugenia glazioviana' THEN 'Myrtaceae'
WHEN species='Melaleuca parviflora' THEN 'Myrtaceae'
WHEN species='Ophrys oestrifera' THEN 'Orchidaceae'
WHEN species='Orchis tridentata' THEN 'Orchidaceae'
WHEN species='Hedyotis auricularia' THEN 'Rubiaceae'
WHEN species='Hedyotis caerulea' THEN 'Rubiaceae'
WHEN species='Hedyotis corymbosa' THEN 'Rubiaceae'
WHEN species='Psychotria salicifolia' THEN 'Rubiaceae'
WHEN species='Psychotria sessilis' THEN 'Rubiaceae'
WHEN species='Salix glauca' THEN 'Salicaceae'
WHEN species='Rhoicissus tridentata' THEN 'Vitaceae'
ELSE family
END
WHERE family='Unknown' OR family IS NULL
;

-- Set family=NULL for remainder
UPDATE view_full_occurrence_individual
SET scrubbed_family=NULL
WHERE scrubbed_family='Unknown'
;
UPDATE agg_traits
SET scrubbed_family=NULL
WHERE scrubbed_family='Unknown'
;
UPDATE analytical_stem
SET scrubbed_family=NULL
WHERE scrubbed_family='Unknown'
;
UPDATE bien_taxonomy
SET scrubbed_family=NULL
WHERE scrubbed_family='Unknown'
;
UPDATE taxon
SET family=NULL
WHERE family='Unknown'
;

-- Update conserved alternate family names
UPDATE view_full_occurrence_individual
SET scrubbed_family=
CASE
WHEN scrubbed_family='Guttiferae' THEN 'Cluisaceae'
WHEN scrubbed_family='Gramineae' THEN 'Poaceae'
WHEN scrubbed_family='Labiatae' THEN 'Lamiaceae'
WHEN scrubbed_family='Palmae' THEN 'Arecaceae'
ELSE scrubbed_family
END
WHERE scrubbed_family IN ('Guttiferae','Gramineae','Labiatae','Palmae')
;
UPDATE agg_traits
SET scrubbed_family=
CASE
WHEN scrubbed_family='Guttiferae' THEN 'Cluisaceae'
WHEN scrubbed_family='Gramineae' THEN 'Poaceae'
WHEN scrubbed_family='Labiatae' THEN 'Lamiaceae'
WHEN scrubbed_family='Palmae' THEN 'Arecaceae'
ELSE scrubbed_family
END
WHERE scrubbed_family IN ('Guttiferae','Gramineae','Labiatae','Palmae')
;
UPDATE analytical_stem
SET scrubbed_family=
CASE
WHEN scrubbed_family='Guttiferae' THEN 'Cluisaceae'
WHEN scrubbed_family='Gramineae' THEN 'Poaceae'
WHEN scrubbed_family='Labiatae' THEN 'Lamiaceae'
WHEN scrubbed_family='Palmae' THEN 'Arecaceae'
ELSE scrubbed_family
END
WHERE scrubbed_family IN ('Guttiferae','Gramineae','Labiatae','Palmae')
;
UPDATE bien_taxonomy
SET scrubbed_family=
CASE
WHEN scrubbed_family='Guttiferae' THEN 'Cluisaceae'
WHEN scrubbed_family='Gramineae' THEN 'Poaceae'
WHEN scrubbed_family='Labiatae' THEN 'Lamiaceae'
WHEN scrubbed_family='Palmae' THEN 'Arecaceae'
ELSE scrubbed_family
END
WHERE scrubbed_family IN ('Guttiferae','Gramineae','Labiatae','Palmae')
;
UPDATE taxon
SET family=
CASE
WHEN family='Guttiferae' THEN 'Cluisaceae'
WHEN family='Gramineae' THEN 'Poaceae'
WHEN family='Labiatae' THEN 'Lamiaceae'
WHEN family='Palmae' THEN 'Arecaceae'
ELSE family
END
WHERE family IN ('Guttiferae','Gramineae','Labiatae','Palmae')
;

--
-- Drop indexes
-- 
DROP INDEX IF EXISTS vfoi_scrubbed_species_binomial_scrubbed_family_unknown_idx;
DROP INDEX IF EXISTS agg_traits_scrubbed_species_binomial_scrubbed_family_unknown_idx;
DROP INDEX IF EXISTS bien_taxonomy_scrubbed_species_binomial_scrubbed_family_unknown_idx;
DROP INDEX IF EXISTS taxon_species_family_unknown_idx;
