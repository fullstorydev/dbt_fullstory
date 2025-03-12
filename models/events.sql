{{ config(materialized='view') }}

with events as (

    select
         {{ dbt_utils.star(ref('stg_fullstory__events'), except=["full_session_id_rn", "device_id_rn", "user_id_rn", "latest_user_id"]) }} 
    from {{ ref("stg_fullstory__events") }}

)
select
    *
from events
