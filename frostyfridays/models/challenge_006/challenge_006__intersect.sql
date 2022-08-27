with

region as (
    select nation_or_region_name, region_poly
    from {{ ref('challenge_006__regions') }}
),

constituencies as (
    select constituency, const_poly
    from {{ ref('challenge_006__constituencies')}}
),

intersections as (
    select 
        nation_or_region_name,
        region_poly,
        constituency,
        const_poly,
        st_intersects(region_poly, const_poly) as intersection
    from region cross join constituencies
)

select 
    nation_or_region_name as nation_or_region,
    count(distinct constituency) as intersecting_constituencies
from intersections
where intersection = true
group by 1
order by 2 desc