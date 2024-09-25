-- ----------------------------------------------------------------
-- Remove line endings from name submitted to TNRS
-- ----------------------------------------------------------------

set search_path to :sch;

-- DOS
UPDATE tnrs_submitted
SET name_submitted=regexp_replace(name_submitted, '[\r\n]' , ' ', 'g' )
WHERE name_submitted ~ '\r\n'
;

-- UNIX
UPDATE tnrs_submitted
SET name_submitted=regexp_replace(name_submitted, '[\n]' , ' ', 'g' )
WHERE name_submitted ~ '\n'
;

-- Legacy Mac
UPDATE tnrs_submitted
SET name_submitted=regexp_replace(name_submitted, '[\r]' , ' ', 'g' )
WHERE name_submitted ~ '\r'
;

-- Unicode line separator U2028*+
UPDATE tnrs_submitted
SET name_submitted=regexp_replace(name_submitted, E'[\\n\\r\\u2028]+', ' ', 'g' )
WHERE name_submitted ~ E'[\\n\\r\\u2028]+'
;

-- Other Unicode line separators
UPDATE tnrs_submitted
SET name_submitted=regexp_replace(name_submitted, E'[\\n\\r\\f\\u000B\\u0085\\u2028\\u2029]+', ' ', 'g' )
WHERE name_submitted ~ E'[\\n\\r\\f\\u000B\\u0085\\u2028\\u2029]+'
;
UPDATE tnrs_submitted
SET name_submitted=regexp_replace(name_submitted, E'[\\n\\r\\f\\u000A\\u000C\\u000D]+', ' ', 'g' )
WHERE name_submitted ~ E'[\\n\\r\\f\\u000A\\u000C\\u000D]+'
;

-- Or all in one:
UPDATE tnrs_submitted
SET name_submitted=regexp_replace(name_submitted, E'[\\n\\r\\f\\u000A\\u000C\\u000D\\u000B\\u0085\\u2028\\u2029]+', ' ', 'g' )
WHERE name_submitted ~ E'[\\n\\r\\f\\u000A\\u000C\\u000D\\u000B\\u0085\\u2028\\u2029]+'
;

