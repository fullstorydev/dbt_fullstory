select
    event_id,
    device_id,
    session_id,
    view_id,
    event_time,
    updated_time,
    processed_time,
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
    target_text,
    target_masked,
    target_raw_selector,
    element_definition_id,
    additional_element_definition_ids
from {{ ref("stg_events__all") }} events
where
  event_type = 'click'
