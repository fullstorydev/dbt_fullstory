with x as (
  select PARSE_JSON('{"good_key":"good_value"}') as col
)
select *
from x
where {{ json_value("col", "$") }} != '{"good_key":"good_value"}'
