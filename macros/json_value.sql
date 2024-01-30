{%- macro json_value(column, path, array=False, dtype=none, skip_parse=False) -%}
    {{ return(adapter.dispatch('json_value', 'dbt_fullstory')(column, path, array, dtype, skip_parse)) }}
{% endmacro %}

{%- macro default__json_value(column, path, array, dtype, skip_parse) -%}
{# We need to parse the json if we don't explicitly skip it. #}
{%- if not skip_parse -%}
{# We should round big numbers so that they can be round-tripped from string > double > string. #}
{%- set column = "PARSE_JSON(" + column +",wide_number_mode=>'round')" -%}
{%- endif %}

{%- if array -%}
  JSON_VALUE_ARRAY({{column}}, '{{path}}')
{%- elif dtype == "object" -%}
  JSON_QUERY({{column}}, '{{path}}')
{%- else -%}
  JSON_VALUE({{column}}, '{{path}}')
{%- endif -%}
{%- endmacro -%}

{%- macro snowflake__json_value(column, path, array, dtype, skip_parse) -%}
  {# Remove the leading $. from the path #}
  {%- set path = modules.re.sub('\$\.?', '', path) -%}
  {# Replace dots with colons in the path #}
  {%- set path = modules.re.sub('\.', ':', path) -%}
  {# If there is a path, prefix with a colon #}
  {%- if path != '' -%}
  {%- set path = ':' + path -%}
  {%- endif -%}
  {{column}}{{path}}
{%- endmacro -%}
