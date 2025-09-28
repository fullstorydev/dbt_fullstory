
{%- macro json_value(column, path, array=False, dtype=none, skip_parse=False, column_dtype='STRING', error_handling=none) -%}
    {%- if error_handling is none -%}
        {%- set error_handling = 'safe' if var('fullstory_enable_safe_json_parsing', true) else 'strict' -%}
    {%- endif -%}
    {{ return(adapter.dispatch('json_value', 'dbt_fullstory')(column, path, array, dtype, skip_parse, column_dtype, error_handling)) }}
{% endmacro %}

{%- macro default__json_value(column, path, array, dtype, skip_parse, column_dtype, error_handling) -%}

{# Enhanced JSON parsing with better error handling #}

{%- if not skip_parse -%}
  {%- if column_dtype == 'JSON' -%}
    {# Column is already JSON type, no need to parse #}
    {%- set column = column -%}
  {%- else -%}
    {# Column is STRING or other type, needs to be parsed to JSON first #}
    {%- if error_handling == 'safe' -%}
      {%- set column = "SAFE.PARSE_JSON(" + column + ", wide_number_mode=>'round')" -%}
    {%- else -%}
      {%- set column = "PARSE_JSON(" + column + ", wide_number_mode=>'round')" -%}
    {%- endif -%}
  {%- endif %}
{%- endif -%}

{# Use safe JSON functions when error_handling is safe #}
{%- if array -%}
  JSON_VALUE_ARRAY({{column}}, '{{path}}')
{%- elif dtype == "object" -%}
  JSON_QUERY({{column}}, '{{path}}')
{%- elif dtype == "float64" -%}
  {%- if error_handling == 'safe' -%}
    safe_cast(JSON_VALUE({{column}}, '{{path}}') as float64)
  {%- else -%}
    cast(JSON_VALUE({{column}}, '{{path}}') as float64)
  {%- endif -%}
{%- else -%}
  JSON_VALUE({{column}}, '{{path}}')
{%- endif -%}

{%- endmacro -%}