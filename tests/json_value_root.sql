with x as (
  select '{"good_key":"good_value"}' as col
)
select *
from x
where {{ json_value("col", "$") }} != '{"good_key":"good_value"}'
