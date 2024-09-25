-- -------------------------------------------------------------------
-- Returns t if value is numeric, else f
-- Source: https://stackoverflow.com/questions/16195986/isnumeric-with-postgresql
-- Usage: 
-- SELECT is_numeric(col_txt) from tbl;
-- 
-- UPDATE tbl
-- SET col_number=
-- CASE
-- WHEN is_numeric(col_txt)='t' THEN col_txt::numeric
-- ELSE null
-- END
-- ;
-- -------------------------------------------------------------------

CREATE OR REPLACE FUNCTION is_numeric(text) RETURNS BOOLEAN AS $$
DECLARE x NUMERIC;
BEGIN
    x = $1::NUMERIC;
    RETURN TRUE;
EXCEPTION WHEN others THEN
    RETURN FALSE;
END;
$$
STRICT
LANGUAGE plpgsql IMMUTABLE;
