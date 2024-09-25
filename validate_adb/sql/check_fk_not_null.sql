-- ------------------------------------------------------------
-- Check that at least one validation fk value present in table
-- Requires parameters:
--	$sch --> :sch
-- 	$check_tbl --> :check_tbl
--	$fk_col --> :fk_col
-- ------------------------------------------------------------

SET search_path TO :sch;

SELECT EXISTS (
SELECT :fk_col 
FROM :check_tbl 
WHERE :fk_col IS NOT NULL
LIMIT 1
) AS a;

