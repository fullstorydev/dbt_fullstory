{{
  config(
    unique_key='event_id',
  )
}}

with staging as (

    select
         {{ dbt_utils.star(ref('stg_fullstory__events'), except=["full_session_id_rn", "device_id_rn", "user_id_rn", "latest_user_id"]) }},

         row_number() over(partition by event_id order by updated_time desc, processed_time desc) as event_id_rn
    from {{ ref("stg_fullstory__events") }}

)

select
  {{ dbt_utils.star(ref('stg_fullstory__events'), except=["full_session_id_rn", "device_id_rn", "user_id_rn", "latest_user_id"]) }}
from staging
{% if is_incremental() %}
and
staging.updated_time >=  (select max(staging.updated_time) from {{ this }})  
and
staging.event_time >= {{ dbt.dateadd("hour", incremental_adjustment, dbt.current_timestamp()) }} 
{% endif %}
where event_id_rn = 1