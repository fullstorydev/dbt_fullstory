with x as (
  {%- if target.type == 'redshift' -%}
  select JSON_PARSE('{"good_key":"good_value"}') as col
  {%- elif target.type == 'snowflake' -%}
  select PARSE_JSON('{"good_key":"good_value"}') as col
  {%- else -%}
  select '{"good_key":"good_value"}' as col
  {%- endif -%}
)
select *
from x
where {{ json_value("col", "$.good_key") }} != 'good_value'
