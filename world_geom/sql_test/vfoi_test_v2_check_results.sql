SELECT country_verbatim AS c_vb, 
state_province_verbatim AS sp_vb, 
county_verbatim AS cp_vb, 
country, state_province, county, 
is_in_country_orig AS ii_c_orig,
is_in_country AS ii_c,
is_in_state_province_orig AS ii_sp_orig,
is_in_state_province AS ii_sp,
is_in_county_orig AS ii_cp_orig,
is_in_county AS ii_cp,
is_geovalid_orig as is_gv_orig,
is_geovalid AS is_gv
FROM vfoi_test_full
LIMIT 25;


