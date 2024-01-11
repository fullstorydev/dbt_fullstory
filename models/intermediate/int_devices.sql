select
  device_id,
  device_user_agent,
  device_type,
  device_operating_system,
  device_browser,
  device_browser_version,
  geo_ip_address,
  geo_country,
  geo_region,
  geo_city,
  geo_lat_long,
  source_type,
  event_time,
  event_id,
  row_number() over (
    partition by device_id
    order by event_time desc
  ) as device_num_desc
from {{ ref('stg_events__all') }} events
where
  device_id is not null
  and source_type != 'server' -- exclude server events, they won't have geo or device values.
