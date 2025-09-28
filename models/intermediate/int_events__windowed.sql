{{
  config(
    materialized='ephemeral'
  )
}}

{# This intermediate model handles the expensive window functions separately #}

with events as (
    select * from {{ ref('stg_fullstory__events') }}
)

select
    *,
    -- Move window functions here to isolate expensive operations
    first_value(user_id ignore nulls) over (
        partition by full_session_id
        order by
            event_time desc,
            updated_time desc,
            processed_time desc
        rows between unbounded preceding and unbounded following
    ) as latest_user_id,
    
    -- Add row numbers for deduplication
    row_number() over (
        partition by full_session_id
        order by
            event_time desc,
            updated_time desc,
            processed_time desc
    ) as full_session_id_rn,
    
    row_number() over (
        partition by device_id
        order by
            event_time desc,
            updated_time desc,
            processed_time desc
    ) as device_id_rn,
    
    row_number() over (
        partition by user_id
        order by
            event_time desc,
            updated_time desc,
            processed_time desc
    ) as user_id_rn

from events