with events as (

    select * from {{ ref('stg_fullstory__events') }}
)

, rn_cte as (

    select
        event_id,
        device_id,
        session_id,
        view_id,
        event_time,
        updated_time,
        processed_time,
        source_type,
        user_id,
        user_email,
        user_display_name,
        user_properties
    from events
    where
        event_type = 'identify'
        and user_id is not null
        and user_id_rn = 1

)

select * from events
