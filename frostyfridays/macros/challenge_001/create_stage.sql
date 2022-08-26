{% macro create_stage(stage_name, options) %}

  {% set query %}

    {# Create temporary stage #}
    create or replace temporary stage {{ stage_name }}
    {{ options }};

  {% endset %}

  {% do run_query(query) %}
{% endmacro %}