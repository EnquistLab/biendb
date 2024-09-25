-- -------------------------------------------------------------------
-- Returns t if value is a valid postgres date, else f
-- Source: 
-- https://stackoverflow.com/questions/25374707/check-whether-string-is-a-date-postgresql
-- Usage: 
-- SELECT is_date(col_txt) from tbl;
-- 
-- UPDATE date_collected=
-- CASE
-- WHEN is_numeric(date_collected_txt)='t' THEN date_collected_txt::date
-- ELSE null
-- END
-- ;
--
-- NOTE: Schema qualify if not in public:
-- SELECT public.is_date(col_txt) from tbl;
-- -------------------------------------------------------------------

create or replace function is_date(s varchar) returns boolean as $$
begin
  perform s::date;
  return true;
exception when others then
  return false;
end;
$$ language plpgsql;
