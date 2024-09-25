set search_path to analytical_db;

drop table if exists vfoi_test;
create table vfoi_test (like view_full_occurrence_individual including all);
insert into vfoi_test
select * from view_full_occurrence_individual
limit :TESTLIMIT
;

drop index if exists vfoi_test_catalog_number_idx;
create index vfoi_test_catalog_number_idx on vfoi_test (catalog_number);
