select
  user_id,
  user_email,
  user_display_name,
  user_properties,
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
  devices.processed_time as last_processed_time,
  event_properties
from {{ ref('identifies') }} identifies
join {{ ref('devices') }} devices on identifies.device_id = devices.id and devices.event_seq_num_desc = 1
where identifies.event_seq_num_desc = 1
