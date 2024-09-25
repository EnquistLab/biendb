-- --------------------------------------------------------
-- Indexes table phylogeny and adjusts ownership to make it
-- readable by everyone in bien group
-- --------------------------------------------------------

SET search_path To :dev_schema;

CREATE INDEX phylogeny_phylogeny_version_idx ON phylogeny(phylogeny_version);
CREATE INDEX phylogeny_replicate_idx ON phylogeny(replicate);
CREATE INDEX phylogeny_filename_idx ON phylogeny(filename);

ALTER TABLE phylogeny OWNER TO bien;