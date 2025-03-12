{{
  config(
    materialized='view',
    unique_key='full_session_id',
  )
}}
{% set incremental_adjustment = -1 * var("fullstory_incremental_interval_hours", 7 * 24) %}

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
where
    updated_time >=  (select max(updated_time) from {{ this }})  
    and
    event_time >= {{ dbt.dateadd("hour", incremental_adjustment, dbt.current_timestamp()) }} 
{% endif %}
