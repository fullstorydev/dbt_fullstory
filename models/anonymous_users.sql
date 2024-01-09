select
  devices.device_id,
  devices.device_user_agent as last_device_user_agent,
  devices.device_type as last_device_type,
  devices.device_operating_system as last_device_operating_system,
  devices.device_browser as last_device_browser,
  devices.device_browser_version as last_device_browser_version,
  devices.geo_ip_address as last_geo_ip_address,
  devices.geo_country as last_geo_country,
  devices.geo_region as last_geo_region,
  devices.geo_city as last_geo_city,
  devices.geo_lat_long as last_geo_lat_long,
  devices.event_time as last_event_time,
  devices.event_id as last_event_id,
from {{ ref('int_devices') }} devices
where
  devices.device_id is not null
  and devices.device_num_desc = 1
  and devices.source_type != 'server' -- exclude server events, they won't have geo or device values.
  and devices.device_id not in (
    select device_id
    from {{ ref('identifies') }}
  )