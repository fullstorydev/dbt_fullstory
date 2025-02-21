{{
    config(
        unique_key='event_id'
    )
}}
select
    event_id as event_id,
    device_id,
    session_id,
    view_id,
    event_time,
    event_type,
    source_type,
    updated_time,
    processed_time,
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
from {{ source("fullstory", "events") }}
where
    event_type is not null and
    event_time >= '{{ var("fullstory_min_event_time") }}'
    {% if is_incremental() %}
        -- we can't use the max event_time because event_time is specified by the client. We cannot guarantee
        -- that it is accurate. Instead, we will use the current timestamp, and look back a configurable
        -- distance for updates.
        and cast(event_time as timestamp) >= current_timestamp - {{ var("fullstory_incremental_interval") }}
    {% endif %}
