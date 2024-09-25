-- -------------------------------------------------------------------
-- Returns distance in km between two sets of decimal coordinates
-- 
-- UPDATE tbl
-- dist_km=geodistkm(lat1, long1, lat2, long2)
-- WHERE lat1 IS NOT NULL AND long1 IS NOT NULL 
-- AND lat2 IS NOT NULL AND long2 IS NOT NULL
-- ;
-- -------------------------------------------------------------------

CREATE OR REPLACE FUNCTION geodistkm(lat1 NUMERIC, lon1 NUMERIC, lat2 NUMERIC, lon2 NUMERIC) RETURNS NUMERIC AS $$
DECLARE 
	x NUMERIC;
	pi NUMERIC;
	q1 NUMERIC;
	q2 NUMERIC;
	q3 NUMERIC;
	rads NUMERIC;
	distkm NUMERIC;
BEGIN
	pi := pi();
	lat1 := lat1 * pi / 180; 
	lon1 := lon1 * pi / 180; 
	lat2 := lat2 * pi / 180; 
	lon2 := lon2 * pi / 180; 
	q1 := cos(lon1-lon2); 
	q2 := cos(lat1-lat2); 
	q3 := cos(lat1+lat2); 
	rads := acos( 0.5*((1.0+q1)*q2 - (1.0-q1)*q3) );
	distkm := rads * 6378.388;
    
    RETURN distkm;
END;
$$ LANGUAGE plpgsql STABLE;
