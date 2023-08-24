{%- macro json_pivot(json_string, model_name, project, node_type='model') -%}
    {%- if execute -%}
        {# Step 1 - Get a list of columns from the schema #}
            {# Step 2 - Loop through columns, get JSON string columns only #}
                {# Step 3 - Extract based on Data Type #}
                    {# Step 4 - Get conversion rule if column is a Time Dimension #}
        {%- set anc_meta_key = 'JSON' -%}
        {%- set rule_meta_key = 'rule' -%}
        {%- set datatype_meta_key = 'data_type' -%}
        {%- set columns = [] -%}
        {%- set fqname = node_type ~ '.' ~ project ~ '.' ~ model_name -%}
        {%- set columns = graph.nodes[fqname]['columns']  -%}

        {# Step 1 - Get JSON string Columns only #}
            {# Step 2 - Extract based on Data Type #}
                {# Step 3 - Get Conversion Rule if column is a Time Dimension #}
        {%- for column in columns -%}
            {%- set column_name = column|replace(".", "_") -%}
            {%- set anc_value = (graph.nodes[fqname]['columns'][column]['meta'][anc_meta_key]|upper) -%}
            {%- set rule_value = (graph.nodes[fqname]['columns'][column]['meta'][rule_meta_key]|upper) -%}
            {%- set dt_value = (graph.nodes[fqname]['columns'][column]['meta'][datatype_meta_key]|upper) -%}
            {%- if anc_value == 'TRUE' -%}
                {%- if dt_value == 'STRING' -%}
                    JSON_EXTRACT_SCALAR({{json_string}},'$.{{column}}') as {{column_name}},
                {%- elif dt_value == 'NUMERIC' -%}
                    safe_cast(JSON_EXTRACT_SCALAR({{json_string}},'$.{{column}}') as NUMERIC) as {{column_name}},
                {%- elif dt_value == 'INTEGER' -%}
                    safe_cast(JSON_EXTRACT_SCALAR({{json_string}},'$.{{column}}') as INT64) as {{column_name}},
                {%- elif dt_value == 'FLOAT' -%}
                    safe_cast(JSON_EXTRACT_SCALAR({{json_string}},'$.{{column}}') as FLOAT64) as {{column_name}},
                {%- elif dt_value == 'DATE' -%}
                    {%- if rule_value == 'PARSE' -%}
                        parse_date('%Y%m%d',JSON_EXTRACT_SCALAR({{json_string}},'$.{{column}}')) as {{column_name}},
                    {%- else -%}
                        date(JSON_EXTRACT_SCALAR({{json_string}},'$.{{column}}')) as {{column_name}},
                    {%- endif -%}
                {%- elif dt_value == 'TIME' -%}
                    {%- if rule_value == 'PARSE' -%}
                        parse_time('%H%M%S',JSON_EXTRACT_SCALAR({{json_string}},'$.{{column}}')) as {{column_name}},
                    {%- else -%}
                        time(JSON_EXTRACT_SCALAR({{json_string}},'$.{{column}}')) as {{column_name}},
                    {%- endif -%}
                {%- elif dt_value == 'DATETIME' -%}
                    {%- if rule_value == 'PARSE' -%}
                        parse_datetime('%Y%m%d%H%M%S',JSON_EXTRACT_SCALAR({{json_string}},'$.{{column}}')) as {{column_name}},
                    {%- else -%}
                        datetime(JSON_EXTRACT_SCALAR({{json_string}},'$.{{column}}')) as {{column_name}},
                    {%- endif -%}
                {%- elif dt_value == 'TIMESTAMP' -%}
                    {%- if rule_value == 'PARSE' -%}
                        parse_timestamp('%c',JSON_EXTRACT_SCALAR({{json_string}},'$.{{column}}')) as {{column_name}},
                    {%- else -%}
                        timestamp(JSON_EXTRACT_SCALAR({{json_string}},'$.{{column}}')) as {{column_name}},
                    {%- endif -%}
                {%- else -%}
                    JSON_EXTRACT_SCALAR({{json_string}},'$.{{column}}') as {{column_name}},
                {%- endif -%}
            {%-else -%}
            {%- endif -%}
        {%- endfor -%}
    {%- endif -%}
{%- endmacro -%}