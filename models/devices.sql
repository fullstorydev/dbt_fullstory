{{
  config(
    materialized='incremental',
    unique_key='event_id',
    on_schema_change= 'sync_all_columns'
  )
}}

{% set incremental_adjustment = -1 * var("fullstory_incremental_interval_hours", 7 * 24) %}

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
where
    updated_time >=  (select max(updated_time) from {{ this }})  
    and
    event_time >= {{ dbt.dateadd("hour", incremental_adjustment, dbt.current_timestamp()) }} 
{% endif %}
