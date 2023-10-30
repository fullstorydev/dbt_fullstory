select
  *
from {{ ref('test_pages') }}
where page_id IS NULL