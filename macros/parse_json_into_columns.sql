{%- macro parse_json_into_columns(field, columns) -%}
{%- for column in columns -%}

{%- set paths = [json_value(field, column.path, column.array)] -%}
{%- for path in column.additional_paths -%}
{%- do paths.append(json_value(field, path, false)) -%}
{%- endfor -%}

{%- if column.cast_as -%}
    cast(coalesce({{ paths|join(', ')}}) as {{column.cast_as}}) as {{column.name}}
{%- else -%}
    coalesce({{ paths|join(', ') }}) as {{column.name}}
{%- endif -%}

{%- if not loop.last %},{% endif -%}

{%- endfor -%}
{%- endmacro -%}
