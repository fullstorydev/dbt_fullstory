with events as (

    select * from {{ ref('stg_fullstory__events') }} 
    
)

select
    events.full_session_id as full_session_id,
    {{ dbt.any_value("case when device_id_rn = 1 then user_id end") }} as user_id,
    {{ dbt.any_value("device_id") }} as device_id,
    {{ dbt.any_value("session_id") }} as session_id,
    min(event_time) as start_time,
    max(event_time) as end_time,
    max(updated_time) as updated_time,
    {{- dbt.datediff("min(event_time)", "max(event_time)", "second") -}} as duration,
    count(distinct event_id) as total_events,
    count(
        distinct case when event_type = 'navigate' then event_id end
    ) as total_page_views,
    count(
        distinct case when event_type = 'navigate' then url_full_url end
    ) as total_unique_urls,
    {{ dbt.concat([
        get_replay_url_path(),
        dbt.any_value("device_id"),
        "':'",
        dbt.any_value("session_id"),
        "'?url_source=DD'"
    ]) }} as replay_url,
    {% for type in var("fullstory_events_types") -%}
    count(case when event_type = '{{ type }}' then 1 end) as total_{{ type }}_events{% if not loop.last %},{% endif %}
    {% endfor %},
    count(case when source_type = 'web' then 1 end) as total_web_events,
    count(case when source_type = 'mobile_app' then 1 end) as total_mobile_app_events
    from  events
    where
        full_session_id is not null
    {{ dbt_utils.group_by(n=1) }}
