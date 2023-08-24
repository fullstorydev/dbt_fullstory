select
    user_id,
    device_id,
    row_number() over (
        partition by device_id
        order by
            event_time desc,
            updated_time desc,
            processed_time desc
    ) as desc_row_num
from {{ ref("stg_events__all") }}
where
    user_id is not null
