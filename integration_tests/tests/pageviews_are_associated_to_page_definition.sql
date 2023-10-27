select
  *
from {{ ref('test_pageviews') }}
where page_id IS NULL