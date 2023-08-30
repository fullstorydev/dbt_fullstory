{{
    config(
        materialized='view',
        unique_key='full_session_id'
    )
}}
select
    base.full_session_id,
    coalesce(base.user_id, {{ dbt.concat(["'anon_'", "base.device_id"]) }}) as user_id,
    base.device_id,
    base.session_id,
    base.start_time,
    base.end_time,
    base.updated_time,
    sources.source_type as last_source_type,
    emails.user_email as last_email,
    display_names.user_display_name as last_display_name,
    devices.device_user_agent as last_user_agent,
    devices.device_type as last_device_type,
    devices.device_operating_system as last_operating_system,
    devices.device_browser as last_browser,
    devices.device_browser_version as last_browser_version,
    locations.geo_ip_address as last_ip_address,
    locations.geo_country as last_country,
    locations.geo_region as last_region,
    locations.geo_city as last_city,
    locations.geo_lat_long as last_lat_long,
    base.duration,
    base.replay_url,
    base.total_events,
    base.total_web_events,
    base.total_mobile_app_events,
    base.total_page_views,
    base.total_unique_urls,
    {% for type in var("fullstory_events_types") -%}
    base.total_{{ type }}_events{% if not loop.last %},{% endif %}
    {% endfor %},
    row_number() over (
        partition by base.user_id
        order by
            base.end_time desc,
            base.full_session_id desc
    ) as desc_row_num
from {{ ref("int_sessions") }} as base
left join
    {{ ref("stg_events__source_types") }} as sources
    on sources.desc_row_num = 1
    and base.full_session_id = sources.full_session_id
left join
    {{ ref("stg_events__emails") }} as emails
    on emails.desc_row_num = 1
    and base.full_session_id = emails.full_session_id
left join
    {{ ref("stg_events__display_names") }} as display_names
    on display_names.desc_row_num = 1
    and base.full_session_id = display_names.full_session_id
left join
    {{ ref("stg_events__devices") }} as devices
    on devices.desc_row_num = 1
    and base.full_session_id = devices.full_session_id
left join
    {{ ref("stg_events__locations") }} as locations
    on locations.desc_row_num = 1
    and base.full_session_id = locations.full_session_id
