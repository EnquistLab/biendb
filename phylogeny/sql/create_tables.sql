-- --------------------------------------------------------
-- Creates tables phylogeny for phylogeny module
-- --------------------------------------------------------

SET search_path To :dev_schema;

-- Table of alternative newick phylogenies and metadata
DROP TABLE IF EXISTS phylogeny;
CREATE TABLE phylogeny (
phylogeny_id SERIAL PRIMARY KEY NOT NULL,
phylogeny_version TEXT NOT NULL,
replicate INT DEFAULT NULL,
filename TEXT NOT NULL,
citation TEXT NOT NULL,
phylogeny TEXT DEFAULT NULL
);

-- Temporary table for importing metadata
DROP TABLE IF EXISTS phylo_info;
CREATE TABLE phylo_info (
citation TEXT NOT NULL,
phylogeny_version TEXT NOT NULL,
replicate CHARACTER(12) DEFAULT NULL,
filename TEXT NOT NULL
);

