{{ config(
    pre_hook = "create stage if not exists challenge_002__int_stage; 
                PUT file://./models/challenge_002/employees.parquet @challenge_002__int_stage;
                create or replace table challenge_002__raw (data_raw variant);
                copy into challenge_002__raw from (
                select $1 from @challenge_002__int_stage/employees.parquet )
                file_format = (type=PARQUET);",
    materialized='table'
) }}

select 
    data_raw:employee_id::varchar employee_id,
    data_raw:dept::varchar dept,
    data_raw:job_title::varchar job_title,
    data_raw:country::varchar country,
    data_raw:last_name::varchar last_name,
    data_raw:title::varchar title
from challenge_002__raw