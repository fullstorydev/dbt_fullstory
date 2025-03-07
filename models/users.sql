{{
    config(
        materialized='view',
        unique_key='user_id'
    )
}}
select
    base.user_id,
    base.updated_time,
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
from {{ ref("int_events__users") }} as base
join {{ ref("sessions") }} as sessions
    on desc_row_num = 1
    and base.user_id = sessions.user_id
{% if is_incremental() %}
  -- we can't use the max event_time because event_time is specified by the client. We cannot guarantee
  -- that it is accurate. Instead, we will use the current timestamp, and look back a configurable
  -- distance for updates.
  where
   {{ dbt.cast("event_time", api.Column.translate_type("datetime")) }} >= {{ dbt.dateadd(datepart="hour", interval=-1 * var("fullstory_incremental_interval_hours", 7 * 24), from_date_or_timestamp=dbt.current_timestamp()) }}
{% endif %}
