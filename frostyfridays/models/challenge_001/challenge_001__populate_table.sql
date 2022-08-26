{{ config(
    pre_hook= challenge_001__stage_external('challenge_001_stage', 's3://frostyfridaychallenges/challenge_1/', ['result'], ['varchar']),
    materialized='table'
) }}

select * from {{ this }}