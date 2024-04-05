{%- macro cast(column, as) -%}
    {{ return(adapter.dispatch('cast', 'dbt_fullstory')(column, as)) }}
{%- endmacro -%}

{%- macro default__cast(column, as) -%}
{{- dbt.safe_cast(column, as) -}}
{%- endmacro -%}

{%- macro snowflake__cast(column, as) -%}
{# We don't want to use try_cast for Snowflake. You can't use try_cast on a variant type. #}
cast({{column}} as {{ api.Column.translate_type(as)}})
{%- endmacro -%}
