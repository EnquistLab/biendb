Dependencies

1. Postgres extension tablefunc 
- install in public:

\c vegbien
CREATE EXTENSION tablefunc;

- in public, no need to use schema qualifier:

SELECT *
FROM crosstab(
  'select rowid, attribute, value
   from ct
   where attribute = ''att2'' or attribute = ''att3''
   order by 1,2')
AS ct(row_name text, category_1 text, category_2 text, category_3 text);

- call from other schema using schema qualifier:

set search_path to analytical_db_dev

SELECT *
FROM public.crosstab(
  'select rowid, attribute, value
   from ct
   where attribute = ''att2'' or attribute = ''att3''
   order by 1,2')
AS ct(row_name text, category_1 text, category_2 text, category_3 text);

2. UNIX utility iconv
- For converting character sets, e.g.,
iconv -f ISO-8859-1 -t UTF-8 traits_3_21_2017.csv > traits_3_21_2017_utf8.csv

3. UNIX utility dos29unix
- Converts DOS line endings to UNIX line endings. E.g.,
dos2unix traits_3_21_2017_utf8.csv


