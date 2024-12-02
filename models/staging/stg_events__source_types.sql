select
    full_session_id,
    session_id,
    device_id,
    view_id,
    event_time,
    updated_time,
    processed_time,
    source_type,
    events.source_properties.url.full_url as page_url,
    row_number() over (
        partition by full_session_id
        order by
            event_time desc,
            updated_time desc,
            processed_time desc
    ) as desc_row_num
from {{ ref("events") }}
