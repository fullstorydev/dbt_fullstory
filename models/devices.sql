select
  device_id as id,
  device_user_agent as user_agent,
  device_type as type,
  device_operating_system as operating_system,
  device_browser as browser,
  device_browser_version as browser_version,
  geo_ip_address,
  geo_country,
  geo_region,
  geo_city,
  geo_lat_long,
  source_type,
  event_id,
  event_time,
  updated_time,
  processed_time,
  row_number() over (
    partition by device_id
    order by event_time desc
  ) as device_num_desc
from {{ ref('events') }} events
where
  device_id is not null
  and source_type != 'server' -- exclude server events, they won't have geo or device values.
