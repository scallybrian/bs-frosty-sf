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
nations_and_regions as (
    select
        st_point($4,$5) as poly_pts,
        $1 as nation_or_region_name,
        $2 as type,
        $3 as sequence_num,
        $4 as longitude,
        $5 as latitude,
        $6 as part,
        metadata$filename as file_name,
        metadata$file_row_number as row_number 
    from @challenge_006__stage/nations_and_regions.csv
),

nr_geo as (
    select
        nation_or_region_name,
        type,
        part,
        st_polygon(to_geography(linestring(longitude, latitude))) as region_poly
    from nations_and_regions
    group by 1,2,3
)

select * from nr_geo