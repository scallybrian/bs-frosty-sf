{{ config(
    materialized='view'
) }}

select *
from challenge_002__stream