-- This model exists as a way to sequence the sessions in order for a user. The desc_row_num
-- column cannot be part of a materialized table because of late arriving events.
-- Example: We have a session for user id 'alice' with a desc_row_num of 1. On the next incremental
-- run, we get another new session. `desc_row_num` would be calculated as 1 again, and now we would
-- have two sessions with `desc_row_num = 1`. This would cause down stream tables to fail since
-- we typically look for a single row where `desc_row_num = 1` to display the latest data.
select
  *,
  row_number() over (
    partition by user_id
    order by
        end_time desc,
        full_session_id desc
  ) as desc_row_num
from {{ ref('sessions') }}