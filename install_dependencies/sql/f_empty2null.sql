-- Coverts all empty string to null in table
-- Source: https://stackoverflow.com/questions/10621897/replace-empty-strings-with-null-values
-- Usage: 
-- SELECT f_empty2null('mytable');
-- SELECT f_empty2null('myschema.mytable');
-- To also get the column name updated_rows:
-- SELECT * FROM f_empty2null('mytable');

CREATE OR REPLACE FUNCTION f_empty2null(_tbl regclass, OUT updated_rows int) AS
$func$
DECLARE
   -- basic char types, possibly extend with citext, domains or custom types:
   _typ  CONSTANT regtype[] := '{text, bpchar, varchar, \"char\"}';
   _sql  text;
BEGIN
   SELECT INTO _sql     -- build command
          format('UPDATE %s SET %s WHERE %s'
               , _tbl
               , string_agg(format($$%1$s = NULLIF(%1$s, '')$$, col), ', ')
               , string_agg(col || $$ = ''$$, ' OR '))
   FROM  (
      SELECT quote_ident(attname) AS col
      FROM   pg_attribute
      WHERE  attrelid = _tbl              -- valid, visible, legal table name 
      AND    attnum >= 1                  -- exclude tableoid & friends
      AND    NOT attisdropped             -- exclude dropped columns
      AND    NOT attnotnull               -- exclude columns defined NOT NULL!
      AND    atttypid = ANY(_typ)         -- only character types
      ORDER  BY attnum
      ) sub;

   -- Test
   -- RAISE NOTICE '%', _sql;

   -- Execute
   IF _sql IS NULL THEN
      updated_rows := 0;                         -- nothing to update
   ELSE
      EXECUTE _sql;
      GET DIAGNOSTICS updated_rows = ROW_COUNT;  -- Report number of affected rows
   END IF;
END
$func$  LANGUAGE plpgsql;
