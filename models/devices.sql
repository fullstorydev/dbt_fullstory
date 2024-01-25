select
  event_id,
  device_id as id,
  event_time,
  updated_time,
  processed_time,
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
  row_number() over (
    partition by device_id
    order by event_time desc
  ) as event_seq_num_desc
from {{ ref('events') }} events
where
  device_id is not null
  and source_type != 'server' -- exclude server events, they won't have geo or device values.
