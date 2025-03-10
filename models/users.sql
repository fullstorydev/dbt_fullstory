{{
    config(
        materialized='table',
        unique_key='user_id'
    )
}}

with sessions_cte as (

    select * from {{ ref("sessions") }}
    where user_id is not null

)

, user_aggregation as (

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
    from sessions_cte
    {{ dbt_utils.group_by(n=1) }}

)

select
    user_aggregation.user_id,
    user_aggregation.updated_time,
    user_aggregation.last_event_time,
    sessions_cte.last_email as last_email,
    sessions_cte.last_display_name as last_display_name,
    sessions_cte.last_user_agent as last_user_agent,
    sessions_cte.last_device_type as last_device_type,
    sessions_cte.last_operating_system as last_operating_system,
    sessions_cte.last_browser as last_browser,
    sessions_cte.last_browser_version as last_browser_version,
    sessions_cte.last_ip_address as last_ip_address,
    sessions_cte.last_country as last_country,
    sessions_cte.last_region as last_region,
    sessions_cte.last_city as last_city,
    sessions_cte.last_lat_long as last_lat_long,
    user_aggregation.total_events,
    user_aggregation.total_sessions,
    user_aggregation.total_session_duration,
    user_aggregation.total_web_events,
    user_aggregation.total_web_sessions,
    user_aggregation.total_mobile_app_events,
    user_aggregation.total_mobile_app_sessions,
    {% for type in var("fullstory_events_types") -%}
    user_aggregation.total_{{ type }}_events{% if not loop.last %},{% endif %}
    {% endfor %}
from user_aggregation
inner join sessions_cte
    on desc_row_num = 1
    and user_aggregation.user_id = sessions_cte.user_id
