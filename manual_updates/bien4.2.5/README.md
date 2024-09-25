# Hotfix 4.2.5: Refactor table species\_by\_political\_division

* Fixes PK violations and other errors in original table `species_by_political_division`, used by R BIEN package.
* Ensure that `scrubbed_species_binomial` + `country` + `state_province` + `county` are a candidate PK (i.e., unique index)
* Adds NSR fields `is_introduced` and `native_status`
* Removes field `is_cultivated_observation` (not unique at leves of species + political divisions; was creating PK violations
* Update BIEN DB version to 4.2.5
* Added to BIEN pipeline, ready to go

