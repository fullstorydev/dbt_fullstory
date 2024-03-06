{%- macro cast(column, as) -%}
    {{ return(adapter.dispatch('cast', 'dbt_fullstory')(column, as)) }}
{%- endmacro -%}

{%- macro default__cast(column, as) -%}
{{- dbt.safe_cast(column, as) -}}
{%- endmacro -%}

{%- macro redshift__cast(column, as) -%}
{%- if as == dbt.type_boolean() -%}
CASE {{ column }}
WHEN 'true' THEN TRUE
WHEN 'false' THEN FALSE
ELSE NULL
END
{%- else -%}
{{- dbt.safe_cast(column, as) -}}
{%- endif -%}
{%- endmacro -%}
