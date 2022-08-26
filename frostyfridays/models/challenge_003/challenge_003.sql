{{ config(
    pre_hook = create_stage(
        stage_name = 'challenge_003__stage', 
        options = "url = 's3://frostyfridaychallenges/challenge_3/' file_format = (type = 'CSV', skip_header = 1)", 
        ),
    materialized='table'
) }}

with 
base as (
    select     
        $1 as keyword,
        metadata$filename as file_name,
        metadata$file_row_number as row_number
    from @challenge_003__stage/keywords.csv
)

select 
    metadata$filename as file_name,
    metadata$file_row_number as row_number
from @challenge_003__stage/
where metadata$filename like any (select '%'||keyword||'%' from base)