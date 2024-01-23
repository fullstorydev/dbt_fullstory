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
                    "cast_as": "string",
                },
                {
                    "name": "device_type",
                    "path": "$.user_agent.device",
                    "cast_as": "string",
                },
                {
                    "name": "device_operating_system",
                    "path": "$.user_agent.operating_system",
                    "cast_as": "string",
                },
                {
                    "name": "device_browser",
                    "path": "$.user_agent.browser",
                    "cast_as": "string",
                },
                {
                    "name": "device_browser_version",
                    "path": "$.user_agent.browser_version",
                    "cast_as": "string",
                },
                {
                    "name": "geo_ip_address",
                    "path": "$.location.ip_address",
                    "cast_as": "string",
                },
                {
                    "name": "geo_country",
                    "path": "$.location.country",
                    "cast_as": "string",
                },
                {
                    "name": "geo_region",
                    "path": "$.location.region",
                    "cast_as": "string",
                },
                {
                    "name": "geo_city",
                    "path": "$.location.city",
                    "cast_as": "string"
                },
                {
                    "name": "geo_lat_long",
                    "path": "$.location.lat_long",
                    "cast_as": "string",
                },
                {
                    "name": "url_full_url",
                    "path": "$.url.full_url",
                    "cast_as": "string",
                },
                {
                    "name": "url_host",
                    "path": "$.url.host",
                    "cast_as": "string"
                },
                {
                    "name": "url_path",
                    "path": "$.url.path",
                    "cast_as": "string"
                },
                {
                    "name": "url_query",
                    "path": "$.url.query",
                    "cast_as": "string"
                },
                {
                    "name": "url_hash_path",
                    "path": "$.url.hash_path",
                    "cast_as": "string",
                },
                {
                    "name": "url_hash_query",
                    "path": "$.url.hash_query",
                    "cast_as": "string",
                },
                {
                    "name": "initial_referrer_full_url",
                    "path": "$.initial_referrer.full_url",
                    "cast_as": "string",
                },
                {
                    "name": "initial_referrer_host",
                    "path": "$.initial_referrer.host",
                    "cast_as": "string",
                },
                {
                    "name": "initial_referrer_path",
                    "path": "$.initial_referrer.path",
                    "cast_as": "string",
                },
                {
                    "name": "initial_referrer_query",
                    "path": "$.initial_referrer.query",
                    "cast_as": "string",
                },
                {
                    "name": "initial_referrer_hash_path",
                    "path": "$.initial_referrer.hash_path",
                    "cast_as": "string",
                },
                {
                    "name": "initial_referrer_hash_query",
                    "path": "$.initial_referrer.hash_query",
                    "cast_as": "string",
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
                    "cast_as": "string"
                },
                {
                    "name": "target_masked",
                    "path": "$.target.masked",
                    "cast_as": "boolean",
                    "prefix": "coalesce(",
                    "postfix": ", FALSE)",
                },
                {
                    "name": "target_raw_selector",
                    "path": "$.target.raw_selector",
                    "cast_as": "string",
                },
                {
                    "name": "element_definition_id",
                    "path": "$.target.element_definition_id",
                    "cast_as": "string",
                },
                {
                    "name": "additional_element_definition_ids",
                    "path": "$.target.additional_element_definition_ids",
                    "array": true,
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
                    "cast_as": "string"
                },
                {
                    "name": "user_email",
                    "path": "$.user_email",
                    "cast_as": "string"
                },
                {
                    "name": "user_display_name",
                    "path": "$.user_display_name",
                    "cast_as": "string",
                },
                {
                    "name": "user_properties",
                    "path": "$.user_properties",
                    "dtype": "object",
                },
                {
                    "name": "event_properties",
                    "path": "$.event_properties",
                    "dtype": "json",
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
        and event_time >= current_timestamp - {{ var("fullstory_incremental_interval") }}
    {% endif %}
