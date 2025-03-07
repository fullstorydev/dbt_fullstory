with devices as (

    select * from {{ ref('int_events__display_names') }}

)

select
    full_session_id,
    session_id,
    device_id,
    view_id,
    event_time,
    updated_time,
    processed_time,
    user_display_name
from devices
{% if is_incremental() %}
  -- we can't use the max event_time because event_time is specified by the client. We cannot guarantee
  -- that it is accurate. Instead, we will use the current timestamp, and look back a configurable
  -- distance for updates.
  where
   {{ dbt.cast("event_time", api.Column.translate_type("datetime")) }} >= {{ dbt.dateadd(datepart="hour", interval=-1 * var("fullstory_incremental_interval_hours", 7 * 24), from_date_or_timestamp=dbt.current_timestamp()) }}
{% endif %}
