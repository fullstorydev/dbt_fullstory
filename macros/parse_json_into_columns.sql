{%- macro parse_json_into_columns(field, columns, field_dtype='STRING', error_handling=none) -%}
    {%- if error_handling is none -%}
        {%- set error_handling = 'safe' if var('fullstory_enable_safe_json_parsing', true) else 'strict' -%}
    {%- endif -%}
    {{ return(adapter.dispatch('parse_json_into_columns', 'dbt_fullstory')(field, columns, field_dtype, error_handling)) }}
{% endmacro %}

{%- macro default__parse_json_into_columns(field, columns, field_dtype, error_handling) -%}
    
    {%- for column in columns -%}
        {%- set inner = json_value(field, column.path, column.array, column.dtype, column.skip_parse, field_dtype, error_handling) -%}
        
        {{ column.prefix -}}
        {%- if column.cast_as -%}
            {%- if error_handling == 'safe' -%}
                safe_cast({{ inner }} as {{ column.cast_as }})
            {%- else -%}
                cast({{ inner }} as {{ column.cast_as }})
            {%- endif -%}
        {%- else -%}
            {{ inner }}
        {%- endif -%}
        {{ column.postfix }} as {{ column.name }}
        
        {%- if not loop.last -%},{%- endif -%}
    {%- endfor -%}
    
{%- endmacro -%}
