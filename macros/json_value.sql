{%- macro json_value(column, path, array=False, dtype=none) -%}
    {{ return(adapter.dispatch('json_value', 'dbt_fullstory')(column, path, array, dtype)) }}
{% endmacro %}

{%- macro default__json_value(column, path, array, dtype) -%}
{%- if array -%}
  JSON_VALUE_ARRAY({{column}}, '{{path}}')
{%- elif dtype == "object" -%}
  JSON_QUERY({{column}}, '{{path}}')
{%- else -%}
  JSON_VALUE({{column}}, '{{path}}')
{%- endif -%}
{%- endmacro -%}

{%- macro snowflake__json_value(column, path, array, dtype) -%}
  {# Remove the leading $. from the path #}
  {% set path = modules.re.sub('\$\.', '', path) %}
  {# Replace dots with colons in the path #}
  {% set path = modules.re.sub('\.', ':', path) %}
  parse_json({{column}}):{{path}}
{%- endmacro -%}
