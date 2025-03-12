select
  {{ dbt.cast("event_id", api.Column.translate_type("string")) }} as event_id,
  {{ dbt.cast("device_id", api.Column.translate_type("string")) }} as device_id,
  {{ dbt.cast("session_id", api.Column.translate_type("string")) }} as session_id,
  {{ dbt.cast("view_id", api.Column.translate_type("string")) }} as view_id,
  {{ dbt.cast("event_time", api.Column.translate_type("datetime")) }} as event_time,
  {{ dbt.cast("event_type", api.Column.translate_type("string")) }} as event_type,
  {{ dbt.cast("source_type", api.Column.translate_type("string")) }} as source_type,
  {{ dbt.cast("updated_time", api.Column.translate_type("datetime")) }} as updated_time,
  {{ dbt.cast("processed_time", api.Column.translate_type("datetime")) }} as processed_time,
  JSON_PARSE(event_properties::varchar) as event_properties,
  JSON_PARSE(source_properties::varchar) as source_properties
from {{ ref('fullstory_events_integration_seeds') }}
