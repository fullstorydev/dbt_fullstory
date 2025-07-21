with source as (

    select * from {{ source("fullstory", "events") }}
)

, renamed as (

    select
        {{ dbt.cast("event_id", api.Column.translate_type("string")) }} as event_id,
        {{ dbt.cast("device_id", api.Column.translate_type("string")) }} as device_id,
        {{ dbt.cast("session_id", api.Column.translate_type("string")) }} as session_id,
        {{ dbt.cast("view_id", api.Column.translate_type("string")) }} as view_id,
        {{ dbt.cast("event_time", api.Column.translate_type("datetime")) }} as event_time,
        {{ dbt.cast("event_type", api.Column.translate_type("string")) }} as event_type,
        {{ dbt.cast("source_type", api.Column.translate_type("string")) }} as source_type,
        coalesce(
            {{ dbt.cast("updated_time", api.Column.translate_type("datetime")) }},
            {{ dbt.cast("processed_time", api.Column.translate_type("datetime")) }}
            ) as updated_time,
        {{ dbt.cast("processed_time", api.Column.translate_type("datetime")) }} as processed_time,
        {{ dbt.concat(["device_id", "':'", "session_id"]) }} as full_session_id,
        {{
            parse_json_into_columns(
                "source_properties",
                [
                    {
                        "name": "device_user_agent",
                        "path": "$.user_agent.raw_user_agent",
                        "skip_parse": var("fullstory_skip_json_parse", False),
                        "cast_as": dbt.type_string(),
                    },
                    {
                        "name": "device_type",
                        "path": "$.user_agent.device",
                        "skip_parse": var("fullstory_skip_json_parse", False),
                        "cast_as": dbt.type_string(),
                    },
                    {
                        "name": "device_operating_system",
                        "path": "$.user_agent.operating_system",
                        "skip_parse": var("fullstory_skip_json_parse", False),
                        "cast_as": dbt.type_string(),
                    },
                    {
                        "name": "device_browser",
                        "path": "$.user_agent.browser",
                        "skip_parse": var("fullstory_skip_json_parse", False),
                        "cast_as": dbt.type_string(),
                    },
                    {
                        "name": "device_browser_version",
                        "path": "$.user_agent.browser_version",
                        "skip_parse": var("fullstory_skip_json_parse", False),
                        "cast_as": dbt.type_string(),
                    },
                    {
                        "name": "geo_ip_address",
                        "path": "$.location.ip_address",
                        "skip_parse": var("fullstory_skip_json_parse", False),
                        "cast_as": dbt.type_string(),
                    },
                    {
                        "name": "geo_country",
                        "path": "$.location.country",
                        "skip_parse": var("fullstory_skip_json_parse", False),
                        "cast_as": dbt.type_string(),
                    },
                    {
                        "name": "geo_region",
                        "path": "$.location.region",
                        "skip_parse": var("fullstory_skip_json_parse", False),
                        "cast_as": dbt.type_string(),
                    },
                    {
                        "name": "geo_city",
                        "path": "$.location.city",
                        "skip_parse": var("fullstory_skip_json_parse", False),
                        "cast_as": dbt.type_string(),
                    },
                    {
                        "name": "geo_lat_long",
                        "path": "$.location.lat_long",
                        "skip_parse": var("fullstory_skip_json_parse", False),
                        "cast_as": dbt.type_string(),
                    },
                    {
                        "name": "url_full_url",
                        "path": "$.url.full_url",
                        "skip_parse": var("fullstory_skip_json_parse", False),
                        "cast_as": dbt.type_string(),
                    },
                    {
                        "name": "url_host",
                        "path": "$.url.host",
                        "skip_parse": var("fullstory_skip_json_parse", False),
                        "cast_as": dbt.type_string(),
                    },
                    {
                        "name": "url_path",
                        "path": "$.url.path",
                        "skip_parse": var("fullstory_skip_json_parse", False),
                        "cast_as": dbt.type_string(),
                    },
                    {
                        "name": "url_query",
                        "path": "$.url.query",
                        "skip_parse": var("fullstory_skip_json_parse", False),
                        "cast_as": dbt.type_string(),
                    },
                    {
                        "name": "url_hash_path",
                        "path": "$.url.hash_path",
                        "skip_parse": var("fullstory_skip_json_parse", False),
                        "cast_as": dbt.type_string(),
                    },
                    {
                        "name": "url_hash_query",
                        "path": "$.url.hash_query",
                        "skip_parse": var("fullstory_skip_json_parse", False),
                        "cast_as": dbt.type_string(),
                    },
                    {
                        "name": "initial_referrer_full_url",
                        "path": "$.initial_referrer.full_url",
                        "skip_parse": var("fullstory_skip_json_parse", False),
                        "cast_as": dbt.type_string(),
                    },
                    {
                        "name": "initial_referrer_host",
                        "path": "$.initial_referrer.host",
                        "skip_parse": var("fullstory_skip_json_parse", False),
                        "cast_as": dbt.type_string(),
                    },
                    {
                        "name": "initial_referrer_path",
                        "path": "$.initial_referrer.path",
                        "skip_parse": var("fullstory_skip_json_parse", False),
                        "cast_as": dbt.type_string(),
                    },
                    {
                        "name": "initial_referrer_query",
                        "path": "$.initial_referrer.query",
                        "skip_parse": var("fullstory_skip_json_parse", False),
                        "cast_as": dbt.type_string(),
                    },
                    {
                        "name": "initial_referrer_hash_path",
                        "path": "$.initial_referrer.hash_path",
                        "skip_parse": var("fullstory_skip_json_parse", False),
                        "cast_as": dbt.type_string(),
                    },
                    {
                        "name": "initial_referrer_hash_query",
                        "path": "$.initial_referrer.hash_query",
                        "skip_parse": var("fullstory_skip_json_parse", False),
                        "cast_as": dbt.type_string(),
                    },
                    {
                        "name": "source_properties",
                        "path": "$",
                        "dtype": "object",
                        "skip_parse": var("fullstory_skip_json_parse", False),
                    },
                ],
            )
        }},
        {{
            parse_json_into_columns(
                "event_properties",
                [
                    {
                        "name": "target_text",
                        "path": "$.target.text",
                        "skip_parse": var("fullstory_skip_json_parse", False),
                        "cast_as": dbt.type_string(),
                    },
                    {
                        "name": "target_masked",
                        "path": "$.target.masked",
                        "cast_as": dbt.type_boolean(),
                        "prefix": "coalesce(",
                        "postfix": ", FALSE)",
                        "skip_parse": var("fullstory_skip_json_parse", False),
                    },
                    {
                        "name": "target_raw_selector",
                        "path": "$.target.raw_selector",
                        "skip_parse": var("fullstory_skip_json_parse", False),
                        "cast_as": dbt.type_string(),
                    },
                    {
                        "name": "target_element_properties",
                        "path": "$.target.element_properties",
                        "dtype": "object",
                        "skip_parse": var("fullstory_skip_json_parse", False),
                    },
                    {
                        "name": "element_definition_id",
                        "path": "$.target.element_definition_id",
                        "skip_parse": var("fullstory_skip_json_parse", False),
                        "cast_as": dbt.type_string(),
                    },
                    {
                        "name": "additional_element_definition_ids",
                        "path": "$.target.additional_element_definition_ids",
                        "array": true,
                        "skip_parse": var("fullstory_skip_json_parse", False),
                    },
                ],
            )
        }},
        {{
            parse_json_into_columns(
                "event_properties",
                [
                    {
                        "name": "user_id",
                        "path": "$.user_id",
                        "skip_parse": var("fullstory_skip_json_parse", False),
                        "cast_as": dbt.type_string(),
                    },
                    {
                        "name": "user_email",
                        "path": "$.user_email",
                        "skip_parse": var("fullstory_skip_json_parse", False),
                        "cast_as": dbt.type_string(),
                    },
                    {
                        "name": "user_display_name",
                        "path": "$.user_display_name",
                        "skip_parse": var("fullstory_skip_json_parse", False),
                        "cast_as": dbt.type_string(),
                    },
                    {
                        "name": "user_properties",
                        "path": "$.user_properties",
                        "dtype": "object",
                        "skip_parse": var("fullstory_skip_json_parse", False),
                    },
                    {
                        "name": "event_properties",
                        "path": "$",
                        "dtype": "object",
                        "skip_parse": var("fullstory_skip_json_parse", False),
                    },
                ],
            )
        }}
    from source
    where
    event_type is not null and
    event_time >= '{{ var("fullstory_min_event_time") }}'

)

, add_cols as (

    select
    *,   
    first_value(user_id ignore nulls)  over (
        partition by full_session_id
        order by
            event_time desc,
            updated_time desc,
            processed_time desc
        rows between unbounded preceding and unbounded following
    ) as latest_user_id,
    row_number() over (
        partition by full_session_id
        order by
            event_time desc,
            updated_time desc,
            processed_time desc
    ) as full_session_id_rn,
    row_number() over (
        partition by device_id
        order by
            event_time desc,
            updated_time desc,
            processed_time desc
    ) as device_id_rn,
    row_number() over (
        partition by user_id
        order by
            event_time desc,
            updated_time desc,
            processed_time desc
    ) as user_id_rn
from renamed
)

select
    *
from add_cols
