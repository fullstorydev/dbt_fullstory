select
  CAST(id AS int64) as id,
  fs_link_id,
  name,
  description,
  is_user_defined,
  state,
  created_time,
  created_by,
  modified_time,
  modified_by,
  updated_time
from {{ source('fullstory', 'page_definitions') }}