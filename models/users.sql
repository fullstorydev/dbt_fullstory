{{
    config(
        materialized='view',
        unique_key='user_id'
    )
}}
select
    base.user_id,
    base.updated_time,
    base.last_session_start_time,
    base.last_event_time,
    sessions.last_email as last_email,
    sessions.last_display_name as last_display_name,
    sessions.last_user_agent as last_user_agent,
    sessions.last_device_type as last_device_type,
    sessions.last_operating_system as last_operating_system,
    sessions.last_browser as last_browser,
    sessions.last_browser_version as last_browser_version,
    sessions.last_ip_address as last_ip_address,
    sessions.last_country as last_country,
    sessions.last_region as last_region,
    sessions.last_city as last_city,
    sessions.last_lat_long as last_lat_long,
    sessions.total_page_views as Last_Num_Pages,
    sessions.total_events as Last_Num_Events,
    sessions.duration as Last_Duration,
    base.total_events,
    base.total_sessions,
    base.total_session_duration,
    base.total_web_events,
    base.total_web_sessions,
    base.total_mobile_app_events,
    base.total_mobile_app_sessions,
    {% for type in var("fullstory_events_types") -%}
    base.total_{{ type }}_events{% if not loop.last %},{% endif %}
    {% endfor %}
from {{ ref("int_users") }} as base
join {{ ref("sessions") }} as sessions
    on desc_row_num = 1
    and base.user_id = sessions.user_id
