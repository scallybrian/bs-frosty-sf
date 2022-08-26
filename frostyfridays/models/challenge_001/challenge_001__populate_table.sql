{{ config(
    pre_hook = stage_and_copy(
        stage_name = 'challenge_001_stage', 
        options = 'url = s3://frostyfridaychallenges/challenge_1/', 
        columns = ['result'], 
        column_types = ['varchar'],
        file_type = 'CSV'),
    materialized = 'table'
) }}

select * from {{ this }}