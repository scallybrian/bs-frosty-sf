{{ config(
    pre_hook = [create_stage(
        stage_name = 'challenge_006__stage', 
        options = "url = 's3://frostyfridaychallenges/challenge_6/' file_format = (type = 'CSV', skip_header=1, field_optionally_enclosed_by='0x22')", 
        ),
    """create or replace function linestring(lon string, lat string) returns string as $$ 
        'LINESTRING(' || listagg(lon || ' ' || lat, ',') || ')'
        $$;"""],
    materialized='table'
) }}

with
const as (
    select 
        st_makepoint($3,$4) as coord,
        $1 as constituency,
        $2 as sequence_num,
        $3 as longitude,
        $4 as latitude,
        $5 as part,
        metadata$filename as file_name,
        metadata$file_row_number as row_number 
    from @challenge_006__stage/westminster_constituency_points.csv
),

const_geo as (
    select
        constituency,
        part,
        st_polygon(to_geography(linestring(longitude, latitude))) as const_poly
    from const
    group by 1,2
)

select * from const_geo