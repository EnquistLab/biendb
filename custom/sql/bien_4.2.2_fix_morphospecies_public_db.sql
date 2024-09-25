-- ---------------------------------------------------------
-- Fix badly-formed morphospecies names for plot observations
--
-- NOT YET FIXED IN DB PIPELINE OR TNRS
-- ---------------------------------------------------------

--
-- Update public DB
--

\c public_vegbien

UPDATE analytical_stem
SET scrubbed_species_binomial_with_morphospecies=
CASE
WHEN scrubbed_species_binomial IS NOT NULL THEN scrubbed_species_binomial
WHEN scrubbed_species_binomial IS NULL AND scrubbed_genus IS NOT NULL AND REPLACE(scrubbed_family, scrubbed_genus, '')='ceae' THEN TRIM(REPLACE(scrubbed_species_binomial_with_morphospecies, CONCAT(scrubbed_genus,' ceae '), ''))
WHEN scrubbed_species_binomial IS NULL AND scrubbed_genus IS NOT NULL AND split_part(scrubbed_species_binomial_with_morphospecies,' ',1) LIKE '%aceae' THEN TRIM(REPLACE(scrubbed_species_binomial_with_morphospecies, scrubbed_family, ''))
WHEN scrubbed_family IS NULL AND scrubbed_genus IS NULL THEN verbatim_scientific_name
ELSE scrubbed_species_binomial_with_morphospecies
END
WHERE plot_metadata_id IS NOT NULL
;

UPDATE view_full_occurrence_individual
SET scrubbed_species_binomial_with_morphospecies=
CASE
WHEN scrubbed_species_binomial IS NOT NULL THEN scrubbed_species_binomial
WHEN scrubbed_species_binomial IS NULL AND scrubbed_genus IS NOT NULL AND REPLACE(scrubbed_family, scrubbed_genus, '')='ceae' THEN TRIM(REPLACE(scrubbed_species_binomial_with_morphospecies, CONCAT(scrubbed_genus,' ceae '), ''))
WHEN scrubbed_species_binomial IS NULL AND scrubbed_genus IS NOT NULL AND split_part(scrubbed_species_binomial_with_morphospecies,' ',1) LIKE '%aceae' THEN TRIM(REPLACE(scrubbed_species_binomial_with_morphospecies, scrubbed_family, ''))
WHEN scrubbed_family IS NULL AND scrubbed_genus IS NULL THEN verbatim_scientific_name
ELSE scrubbed_species_binomial_with_morphospecies
END
WHERE plot_metadata_id IS NOT NULL
;

-- retire current version
UPDATE bien_metadata
SET db_retired_date=now()::timestamp::date
WHERE bien_metadata_id=(
SELECT MAX(bien_metadata_id) FROM bien_metadata
);

-- Insert new record for new version
-- Version comments are optional
INSERT INTO bien_metadata (
db_version,
db_release_date,
version_comments,
db_code_version,
rbien_version,
rtodobien_version,
tnrs_version
)
VALUES (
'4.2.2',
now()::timestamp::date,
'Minor release: Fix malformed morphospecies names in column scrubbed_species_binomial_with_morphospecies (plots only, vfoi and analytical stem)',
'4.2.3',
'1.2.3',
'1.2.3',
'5.0'
)
;

