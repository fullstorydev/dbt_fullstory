select
  device_id,
  device_user_agent as last_user_agent,
  device_type as last_type,
  device_operating_system as last_operating_system,
  device_browser as last_browser,
  device_browser_version as last_browser_version,
  geo_ip_address as last_geo_ip_address,
  geo_country as last_geo_country,
  geo_region as last_geo_region,
  geo_city as last_geo_city,
  geo_lat_long as last_lat_long,
  event_time as last_event_time,
  event_id as last_event_id,
from {{ ref('int_devices') }}
where device_num_desc = 1