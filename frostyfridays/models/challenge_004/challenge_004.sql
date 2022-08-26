{{ config(
    pre_hook = create_stage(
        stage_name = 'challenge_004__stage', 
        options = "url = 's3://frostyfridaychallenges/challenge_4/' file_format = (type = 'JSON' strip_outer_array = true)", 
        ),
    materialized='table'
) }}

with 
base as (
    select     
        $1 as json_data,
        metadata$filename as file_name,
        metadata$file_row_number as row_number
    from @challenge_004__stage/
    
),

l1 as (
    select
        json_data,
        json_data:Era::varchar as era,
        json_data:Houses::array as houses
    from challenge_004
    ),
    
l2 as (
    select
        m.index + 1 as inter_house_id,
        row_number() over (order by m.value:"Birth"::date) as id,
        era,
        h.value:House::varchar as house,
        m.value:"Age at Time of Death"::varchar as age_at_time_of_death,
        m.value:"Birth"::date as birth,
        m.value:"Burial Place"::varchar as burial_place,
        m.value:"Death"::date as death,
        m.value:"Duration"::varchar as duration,
        m.value:"End of Reign"::varchar as end_of_reign,
        m.value:"Name"::varchar as name,
        m.value:"Place of Birth"::varchar as place_of_birth,
        m.value:"Place of Death"::varchar as place_of_death,
        m.value:"Start of Reign"::date as start_of_reign,
        coalesce(m.value:"Consort\/Queen Consort"[0]::varchar, 
                 m.value:"Consort\/Queen Consort"::varchar) as consort_queen_consort_1,
        m.value:"Consort\/Queen Consort"[1]::varchar as consort_queen_consort_2,
        m.value:"Consort\/Queen Consort"[2]::varchar as consort_queen_consort_3,
        coalesce(m.value:"Nickname"[0]::varchar, m.value:"Nickname"::varchar) as nickname_1,
        m.value:"Nickname"[1]::varchar as nickname_2,
        m.value:"Nickname"[2]::varchar as nickname_3
    from l1,
    lateral flatten(input => houses) h,
    lateral flatten(input => h.value:Monarchs) m
    order by id
)

select * from l2