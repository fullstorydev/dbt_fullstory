with events_enriched as (
    select 
        concat(device_id, ':', session_id) as full_session_id
        , session_id
        , event_id
        , event_time as event_start_time
        , lag(event_time) over(partition by session_id order by event_time desc) as event_end_time
        , timediff(seconds, event_start_time, event_end_time) as event_duration_seconds
        , view_id
        , event_type
        , case
            when split_part(source_properties:url:path::string, '/', 2) = 'course' then true
            else false
          end as is_course_event
        , source_properties
    from 
        {{ ref("events") }}
    order by
        event_time desc
)

select
    full_session_id
    , sum(event_duration_seconds) as course_event_duration_seconds
from
    events_enriched
where
    is_course_event = true
group by
    1
