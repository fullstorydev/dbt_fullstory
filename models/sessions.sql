{{
    config(
        unique_key='full_session_id'
    )
}}

with int_sessions as (

    select * from {{ ref('int_events__sessions') }}

)


, stg_events as (

    select * from {{ ref('stg_fullstory__events') }}
)

select
    int_sessions.full_session_id,
    coalesce(int_sessions.user_id, {{ dbt.concat(["'anon_'", "int_sessions.device_id"]) }})
        as user_id,
    int_sessions.device_id,
    int_sessions.session_id,
    int_sessions.start_time,
    int_sessions.end_time,
    int_sessions.updated_time,
    int_sessions.duration,
    int_sessions.replay_url,
    int_sessions.total_events,
    int_sessions.total_web_events,
    int_sessions.total_mobile_app_events,
    int_sessions.total_page_views,
    int_sessions.total_unique_urls,
    {% for type in var("fullstory_events_types") -%}
        int_sessions.total_{{ type }}_events{% if not loop.last %},{% endif %}
    {% endfor %},
    row_number() over (
        partition by int_sessions.user_id
        order by
            int_sessions.end_time desc,
            int_sessions.full_session_id desc
    ) as desc_row_num,

    stg_events.source_type as last_source_type,
    stg_events.user_email as last_email,
    stg_events.user_display_name as last_display_name,
    stg_events.device_user_agent as last_user_agent,
    stg_events.device_type as last_device_type,
    stg_events.device_operating_system as last_operating_system,
    stg_events.device_browser as last_browser,
    stg_events.device_browser_version as last_browser_version,
    stg_events.geo_ip_address as last_ip_address,
    stg_events.geo_country as last_country,
    stg_events.geo_region as last_region,
    stg_events.geo_city as last_city,
    stg_events.geo_lat_long as last_lat_long,
from int_sessions
inner join stg_events on int_sessions.full_session_id = stg_events.full_session_id
where stg_events.full_session_id_rn = 1
{% if is_incremental() %}
and
    {{ dbt.cast("base.updated_time", api.Column.translate_type("datetime")) }} >= {{ dbt.dateadd(datepart="hour", interval=-1 * var("fullstory_incremental_interval_hours", 7 * 24), from_date_or_timestamp=dbt.current_timestamp()) }}
{% endif %}