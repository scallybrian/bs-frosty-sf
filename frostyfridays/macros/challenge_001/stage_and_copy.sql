{% macro stage_and_copy(stage_name, options, columns, column_types, file_type) %}

  {% set query %}

    {# Create empty table using user-inputted columns & column types #}
    create table if not exists {{ this }} (
    {% for c, ct in zip(columns, column_types) %}
      {{ c }} {{ ct }} {% if not loop.last %} , {% endif -%}
    {% endfor %}
    );

    {# Create temporary stage #}
    create or replace temporary stage {{ stage_name }}
    {{ options }};

    {# Copy data from stage to table #}
    copy into {{ this }} from @{{ stage_name }}
    file_format = ( type = {{ file_type }} );
  {% endset %}

  {% do run_query(query) %}
{% endmacro %}