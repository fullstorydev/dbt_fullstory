{{
  config(
    materialized='incremental',
    unique_key='user_id',
    on_schema_change= 'sync_all_columns'
  )
}}
{% set incremental_adjustment = -1 * var("fullstory_incremental_interval_hours", 7 * 24) %}

select
  identifies.user_id,
  identifies.user_email,
  identifies.user_display_name,
  identifies.user_properties,
  devices.id as last_device_id,
  devices.user_agent as last_device_user_agent,
  devices.type as last_device_type,
  devices.operating_system as last_device_operating_system,
  devices.browser as last_device_browser,
  devices.browser_version as last_device_browser_version,
  devices.geo_ip_address as last_geo_ip_address,
  devices.geo_country as last_geo_country,
  devices.geo_region as last_geo_region,
  devices.geo_city as last_geo_city,
  devices.geo_lat_long as last_geo_lat_long,
  devices.event_id as last_event_id,
  devices.event_time as last_event_time,
  devices.updated_time as last_updated_time,
  devices.processed_time as last_processed_time
from {{ ref('identifies') }} identifies
inner join {{ ref('devices') }} devices on identifies.device_id = devices.id
where identifies.event_seq_num_desc = 1
and devices.event_seq_num_desc = 1
{% if is_incremental() %}
and
identifies.updated_time >=  (select max(identifies.updated_time) from {{ this }})  
and
identifies.event_time >= {{ dbt.dateadd("hour", incremental_adjustment, dbt.current_timestamp()) }} 
{% endif %}
