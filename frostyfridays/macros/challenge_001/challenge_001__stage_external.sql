{% macro challenge_001__stage_external(stage_name, s3_url, columns, column_types) %}

  {% set query %}

    {# Create empty table using user-inputted columns & column types #}
    create table if not exists {{ this }} (
    {% for c, ct in zip(columns, column_types) %}
      {{ c }} {{ ct }} {% if not loop.last %} , {% endif -%}
    {% endfor %}
    );

    {# Create temporary stage #}
    create or replace temporary stage {{ stage_name }}
    url = {{ s3_url }};

    {# Copy data from stage to table #}
    copy into {{ this }} from @{{ stage_name }}
    file_format = ( type = CSV );
  {% endset %}

  {% do run_query(query) %}
{% endmacro %}