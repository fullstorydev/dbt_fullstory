select
    sessions.user_id as user_id,
    max(sessions.updated_time) as updated_time,
    max(sessions.start_time) as last_session_start_time,
    max(sessions.end_time) as last_event_time,
    sum(total_events) as total_events,
    count(1) as total_sessions,
    sum(sessions.duration) as total_session_duration,
    sum(sessions.total_web_events) as total_web_events,
    count(case when sessions.total_web_events > 0 then 1 end) as total_web_sessions,
    sum(sessions.total_mobile_app_events) as total_mobile_app_events,
    count(case when sessions.total_mobile_app_events > 0 then 1 end) as total_mobile_app_sessions,
    {% for type in var("fullstory_events_types") %}
    sum(sessions.total_{{ type }}_events) as total_{{ type }}_events{% if not loop.last %},{% endif %}
    {% endfor %}
from {{ ref("int_sessions") }} as sessions
where
    user_id is not null
group by sessions.user_id
