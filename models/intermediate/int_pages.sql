select *
from {{ ref('stg_events__all') }} e
where
  e.event_type = 'page_view'
