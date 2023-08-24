select
    full_session_id,
    session_id,
    device_id,
    view_id,
    event_time,
    updated_time,
    processed_time,
    device_user_agent,
    device_type,
    device_operating_system,
    device_browser,
    device_browser_version,
    row_number() over (
        partition by full_session_id
        order by
            event_time desc,
            updated_time desc,
            processed_time desc
    ) as desc_row_num
from {{ ref("stg_events__all") }}
