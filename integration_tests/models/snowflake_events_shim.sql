select
  event_id,
  event_time,
  processed_time,
  updated_time,
  device_id,
  session_id,
  view_id,
  event_type,
  parse_json(event_properties) as event_properties,
  source_type,
  parse_json(source_properties) as source_properties
from {{ ref('fullstory_events_integration_seeds') }}
