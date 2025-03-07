with devices as (

    select * from {{ ref('int_events__devices') }}

)

select
    event_id,
    id,
    event_time,
    updated_time,
    processed_time,
    user_agent,
    {% if target.type == "redshift" -%}"type"{%- else -%}type{%- endif -%},
    operating_system,
    browser,
    browser_version,
    geo_ip_address,
    geo_country,
    geo_region,
    geo_city,
    geo_lat_long,
    source_type,
    event_seq_num_desc
from devices

{% if is_incremental() %}
  -- we can't use the max event_time because event_time is specified by the client. We cannot guarantee
  -- that it is accurate. Instead, we will use the current timestamp, and look back a configurable
  -- distance for updates.
  where
   {{ dbt.cast("event_time", api.Column.translate_type("datetime")) }} >= {{ dbt.dateadd(datepart="hour", interval=-1 * var("fullstory_incremental_interval_hours", 7 * 24), from_date_or_timestamp=dbt.current_timestamp()) }}
{% endif %}
