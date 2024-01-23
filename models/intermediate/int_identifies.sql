select
    event_id,
    device_id,
    session_id,
    view_id,
    event_time,
    updated_time,
    processed_time,
    source_type,
    user_id,
    user_email,
    user_display_name,
    user_properties
    event_properties,
    row_number() over (
      partition by user_id
      order by event_time desc
    ) as identity_num_desc
from {{ ref("stg_events__all") }} events
where
  event_type = 'identify'
  and user_id is not null
