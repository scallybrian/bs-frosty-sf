{{ config(
    pre_hook = create_stage(
        stage_name = 'challenge_001_stage', 
        options = "url = 's3://frostyfridaychallenges/challenge_1/' file_format = (type = 'CSV', skip_header = 1)", 
        ),
    materialized = 'table'
) }}

select 
    $1,
    metadata$filename as file_name,
    metadata$file_row_number as row_number 
from @challenge_001_stage
order by 2,3