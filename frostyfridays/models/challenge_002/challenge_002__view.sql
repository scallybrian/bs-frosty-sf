{{ config(
    post_hook = "create or replace stream challenge_002__stream on view challenge_002__view;
                UPDATE challenge_002__table SET COUNTRY = 'Japan' WHERE EMPLOYEE_ID = 8;
                UPDATE challenge_002__table SET LAST_NAME = 'Forester' WHERE EMPLOYEE_ID = 22;
                UPDATE challenge_002__table SET DEPT = 'Marketing' WHERE EMPLOYEE_ID = 25;
                UPDATE challenge_002__table SET TITLE = 'Ms' WHERE EMPLOYEE_ID = 32;
                UPDATE challenge_002__table SET JOB_TITLE = 'Senior Financial Analyst' WHERE EMPLOYEE_ID = 68;",
    materialized='view'
) }}

select 
    employee_id,
    dept,
    job_title
from {{ref('challenge_002__table')}}