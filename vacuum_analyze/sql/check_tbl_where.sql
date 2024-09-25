-- ------------------------------------------------------------
-- Check that at least one validation fk value present in table
-- Requires parameters:
--	$sch --> :sch
-- 	$check_tbl --> :check_tbl
--	$sql_where --> :fk_col
-- ------------------------------------------------------------

SET search_path TO :sch;

SELECT COUNT(*) AS rows
FROM :"check_tbl"
:sql_where
;