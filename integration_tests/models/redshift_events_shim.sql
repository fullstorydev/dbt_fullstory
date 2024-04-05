select
  event_id,
  event_time,
  processed_time,
  updated_time,
  device_id,
  session_id,
  view_id,
  event_type,
  JSON_PARSE(event_properties::varchar) as event_properties,
  source_type,
  JSON_PARSE(source_properties::varchar) as source_properties
from {{ ref('fullstory_events_integration_seeds') }}
