{%- macro get_array_element(column, index) -%}
    {{ return(adapter.dispatch('get_array_element', 'dbt_fullstory')(column, index)) }}
{% endmacro %}

{%- macro default__get_array_element(column, index) -%}
{{column}}[{{index}}]
{%- endmacro %}
