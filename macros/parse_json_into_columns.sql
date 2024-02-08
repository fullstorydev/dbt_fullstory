{%- macro parse_json_into_columns(field, columns) -%}
{%- for column in columns -%}

{%- set inner = json_value(field, column.path, column.array, column.dtype, column.skip_parse) %}
{{ column.prefix -}}

{%- if column.cast_as -%}
    cast({{inner}} as {{column.cast_as}})
{%- else -%}
    {{ inner }}
{%- endif -%}

{{- column.postfix }} as {{column.name}}
{%- if not loop.last %},{% endif -%}

{%- endfor -%}
{%- endmacro -%}
