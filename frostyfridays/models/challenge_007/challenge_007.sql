
with 
tags as (
    select *
    from snowflake.account_usage.tag_references
    where tag_value = 'Level Super Secret A+++++++'
    ),
    
tags_and_qh as (
    select 
        query_id,
        role_name
    from snowflake.account_usage.query_history qh
    inner join tags t
    on qh.database_name = t.object_database
    and qh.schema_name = t.object_schema
    and upper(qh.query_text) like any (select '%'||upper(tags.object_name)||'%' from tags)
)


select * from tags_and_qh