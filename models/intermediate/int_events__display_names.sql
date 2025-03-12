with events as (
select
    full_session_id,
    session_id,
    device_id,
    view_id,
    event_time,
    updated_time,
    processed_time,
    user_display_name
from {{ ref("stg_fullstory__events") }}
where
    user_display_name is not null
    and event_type = 'identify'
    and full_session_id_rn = 1
)


select * from events
