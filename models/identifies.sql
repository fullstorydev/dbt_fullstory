{{
  config(
    unique_key='event_id',
  )
}}

with identifies as (

    select * from {{ ref("int_events__identifies") }}

)

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
    user_properties,
    row_number() over (
        partition by user_id
        order by event_time desc
    ) as event_seq_num_desc
from identifies
