{{
  config(
    unique_key='event_id',
  )
}}

{% set incremental_adjustment = -1 * var("fullstory_incremental_interval_hours", 7 * 24) %}

with windowed_events as (

    select * from {{ ref('int_events__windowed') }}
    
)

, staging as (

    select
         *,
         row_number() over(partition by event_id order by updated_time desc, processed_time desc) as event_id_rn
    from windowed_events

)

select
  -- Explicit columns from staging (excluding event_id_rn)
  event_id,
  device_id,
  session_id,
  view_id,
  event_time,
  event_type,
  source_type,
  updated_time,
  processed_time,
  full_session_id,
  device_user_agent,
  device_type,
  device_operating_system,
  device_browser,
  device_browser_version,
  geo_ip_address,
  geo_country,
  geo_region,
  geo_city,
  geo_lat_long,
  url_full_url,
  url_host,
  url_path,
  url_query,
  url_hash_path,
  url_hash_query,
  initial_referrer_full_url,
  initial_referrer_host,
  initial_referrer_path,
  initial_referrer_query,
  initial_referrer_hash_path,
  initial_referrer_hash_query,
  source_properties,
  target_text,
  target_masked,
  target_raw_selector,
  target_element_properties,
  element_definition_id,
  additional_element_definition_ids,
  user_id,
  user_email,
  user_display_name,
  user_properties,
  event_properties
from staging
where event_id_rn = 1
{% if is_incremental() %}
and
staging.updated_time >=  (select max(staging.updated_time) from {{ this }})  
and
staging.event_time >= {{ dbt.dateadd("hour", incremental_adjustment, dbt.current_timestamp()) }} 
{% endif %}
