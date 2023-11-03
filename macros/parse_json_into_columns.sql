{%- macro parse_json_into_columns(field, columns) -%}
{%- for column in columns -%}

{%- set inner = json_value(field, column.path, column.array) %}

{%- if inner is none and column.additional_paths|default([])|length > 0 -%}
    {%- for path in column.additional_paths -%}
        {%- set inner = json_value(field, path, column.array) %}
        {%- if inner is not none -%}
            {%- break %}
        {%- endif -%}
    {%- endfor -%}
{%- endif -%}

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
