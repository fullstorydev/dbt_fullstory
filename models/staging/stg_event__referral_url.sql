select
    full_session_id,
    source_properties.initial_referrer.full_url as referral_url,
    row_number() over (
        partition by full_session_id
        order by
            event_time,
            updated_time,
            processed_time
    ) as asc_row_num
from {{ ref("events") }}
