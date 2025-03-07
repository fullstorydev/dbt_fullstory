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
{% if is_incremental() %}
  -- we can't use the max event_time because event_time is specified by the client. We cannot guarantee
  -- that it is accurate. Instead, we will use the current timestamp, and look back a configurable
  -- distance for updates.
  where
   {{ dbt.cast("event_time", api.Column.translate_type("datetime")) }} >= {{ dbt.dateadd(datepart="hour", interval=-1 * var("fullstory_incremental_interval_hours", 7 * 24), from_date_or_timestamp=dbt.current_timestamp()) }}
{% endif %}
