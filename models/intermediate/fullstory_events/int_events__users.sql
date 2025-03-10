with int_events__sessions as (

    select * from {{ ref("int_events__sessions") }}
    where user_id is not null

)

select
    user_id,
    max(updated_time) as updated_time,
    max(end_time) as last_event_time,
    sum(total_events) as total_events,
    count(*) as total_sessions,
    sum(duration) as total_session_duration,
    sum(total_web_events) as total_web_events,
    count(case when total_web_events > 0 then 1 end)
        as total_web_sessions,
    sum(total_mobile_app_events) as total_mobile_app_events,
    count(case when total_mobile_app_events > 0 then 1 end)
        as total_mobile_app_sessions,
    {% for type in var("fullstory_events_types") %}
        sum(total_{{ type }}_events)
            as total_{{ type }}_events

        {% if not loop.last %} ,
        {% endif %}
    {% endfor %}
from int_events__sessions
{{ dbt_utils.group_by(n=1) }}
