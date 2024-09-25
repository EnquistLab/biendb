-- -------------------------------------------------------------
-- Flag as cultivated based on keywords in locality & specimen
-- descriptions
-- -------------------------------------------------------------

SET search_path TO :sch;

-- This query will be slow
-- Initial wild card prevents use of indexes
update cultobs_descriptions
set
is_cultivated_observation=1,
is_cultivated_observation_basis='Keywords in locality'
WHERE
description LIKE '%cultiv%' OR
description LIKE '%planted%' OR
description LIKE '%ornamental%' OR
description LIKE '%garden%' OR
description LIKE '%jardin%' OR
description LIKE '%jardín%' OR
description LIKE '%jardim%' OR
description LIKE '%plantation%' OR
description LIKE '%plantacion%' OR
description LIKE '%plantación%' OR
description LIKE '%universit%' OR
description LIKE '%universidad%' OR
description LIKE '%campus%' OR 
description LIKE '%urban%' OR
description LIKE '%greenhouse%' OR
description LIKE '%arboretum%' OR
description LIKE '%farm%' OR
description LIKE '%weed%' OR
description LIKE '%corn field%'
;