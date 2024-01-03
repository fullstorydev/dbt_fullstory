-- This model exists as a way to sequence the sessions in order for a user. The desc_row_num
-- column cannot be part of a materialized table because of late arriving events.
-- Example: We have a session for user id 'alice' with a desc_row_num of 1. On the next incremental
-- run, we get another new session. `desc_row_num` could be calculated as 1 again, and now we would
-- have two sessions with `desc_row_num = 1` in the incremental table. This would cause down stream
-- incremental tables to fail with the error: UPDATE/MERGE must match at most one source row for
-- each target row.
-- By using a view, we can be sure that `desc_row_num` is always accurate, even if it comes at a
-- performance cost.
select
  *,
  row_number() over (
    partition by user_id
    order by
        end_time desc,
        full_session_id desc
  ) as desc_row_num
from {{ ref('sessions') }}