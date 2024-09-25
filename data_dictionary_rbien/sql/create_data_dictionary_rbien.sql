SET search_path TO :sch;

DROP TABLE IF EXISTS data_dictionary_rbien;
CREATE TABLE data_dictionary_rbien (
field TEXT,
"definition" TEXT,
"values" TEXT,
function_families TEXT
); 

CREATE INDEX data_dictionary_rbien_field_idx ON data_dictionary_rbien (field);

REVOKE ALL ON TABLE data_dictionary_rbien FROM PUBLIC;
ALTER TABLE data_dictionary_rbien OWNER TO bien;
GRANT ALL ON TABLE data_dictionary_rbien TO bien;
GRANT ALL ON TABLE data_dictionary_rbien TO jmcgann;
GRANT SELECT ON TABLE data_dictionary_rbien TO bien_read;
GRANT SELECT ON TABLE data_dictionary_rbien TO public_bien3;
GRANT SELECT ON TABLE data_dictionary_rbien TO public_bien;