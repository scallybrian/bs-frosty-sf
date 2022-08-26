{{ config(
    pre_hook = create_stage(
        stage_name = 'challenge_002__int_stage', 
        options = "url = 's3://frostyfridaychallenges/challenge_2/' file_format = (type = 'PARQUET')", 
        ),
    materialized='table'
) }}

with 
base as (
    select     
        $1 as data_raw,
        metadata$filename as file_name,
        metadata$file_row_number as row_number
    from @challenge_002__int_stage
)

select 
    data_raw:employee_id::varchar employee_id,
    data_raw:dept::varchar dept,
    data_raw:job_title::varchar job_title,
    data_raw:country::varchar country,
    data_raw:last_name::varchar last_name,
    data_raw:title::varchar title
from base