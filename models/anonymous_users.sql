select
  devices.id as device_id,
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
  devices.event_time as last_event_time,
  devices.event_id as last_event_id
from {{ ref('devices') }} devices
where
  devices.id is not null
  and devices.event_seq_num_desc = 1
  and devices.source_type != 'server' -- exclude server events, they won't have geo or device values.
  and devices.id not in (
    select device_id
    from {{ ref('identifies') }}
  )