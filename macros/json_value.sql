
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

{%- macro redshift__json_value(column, path, array, dtype, skip_parse, column_dtype, error_handling) -%}
  {# Handle JSON parsing for Redshift #}
  {%- if not skip_parse and column_dtype == 'STRING' -%}
    {%- set column = "JSON_PARSE(" + column + ")" -%}
  {%- endif -%}

  {# Remove the leading $. from the path #}
  {%- set path = modules.re.sub('\$\.?', '', path) -%}
  {%- set path = modules.re.sub('([^.]+)', '"\g<0>"', path)%}

  {# We can exit early if the path references the root. #}
  {%- if not path -%}
    {{ return(column) }}
  {%- endif -%}

  {%- if array -%}
    {# Redshift does not have native array extraction, return the path access #}
    {{column}}.{{path}}
  {%- elif dtype == "object" -%}
    {{column}}.{{path}}
  {%- else -%}
    {{column}}.{{path}}
  {%- endif -%}
{%- endmacro -%}

{%- macro snowflake__json_value(column, path, array, dtype, skip_parse, column_dtype, error_handling) -%}
  {# Handle JSON parsing for Snowflake #}
  {%- if not skip_parse and column_dtype == 'STRING' -%}
    {%- set column = "PARSE_JSON(" + column + ")" -%}
  {%- endif -%}

  {# Remove the leading $. from the path #}
  {%- set path = modules.re.sub('\$\.?', '', path) -%}
  {# Replace dots with colons in the path #}
  {%- set path = modules.re.sub('\.', ':', path) -%}
  {# If there is a path, prefix with a colon #}
  {%- if path != '' -%}
  {%- set path = ':' + path -%}
  {%- endif -%}

  {%- if array -%}
    {# Snowflake array handling #}
    {{column}}{{path}}
  {%- elif dtype == "object" -%}
    {{column}}{{path}}
  {%- else -%}
    {{column}}{{path}}
  {%- endif -%}
{%- endmacro -%}