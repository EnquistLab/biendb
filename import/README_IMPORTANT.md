# REFACTOR LOADING OF METADATA!

Loading of metadata to datasource_staging is currently inconsistent! All of this information should be loaded from CSV file in the source-specific data directory. This process is handled by general script load_staging_datasource.sql in generic import directory import/sql. 

However, for some source (e.g., GBIF) this information is hard-wired into source specific scripts in source sql directory (e.g., import_GBIF/sql/load_datasource_staging.sql, or values are embedded in source params file. Thus MUST be changed to use the generic process described above.