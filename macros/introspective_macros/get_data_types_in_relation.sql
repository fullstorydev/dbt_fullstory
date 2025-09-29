{% macro get_data_types_in_relation(relation) -%}

{#
    Returns a dictionary of column names and their data types for a given relation.
    Args:
        relation: The relation to get column data types from.
    Returns:
        A dictionary of column names and their data types.
#}

{% set columns = adapter.get_columns_in_relation(relation) %}
{% set data_types = {} %}
{% for column in columns %}
    {% do data_types.update({column.name: column.data_type}) %}
{% endfor %}
{{ return(data_types) }}
{%- endmacro %}


