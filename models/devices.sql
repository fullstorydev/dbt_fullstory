{{
  config(
    unique_key='event_id',
  )
}}

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