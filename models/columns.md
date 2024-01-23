{% docs column_additional_element_definition_ids %}
Any other element definition IDs that match the target element.
{% enddocs %}

{% docs column_event_id %}
The event's unique identifier.
{% enddocs %}

{% docs column_device_browser %}
The browser used by the device.
{% enddocs %}

{% docs column_device_browser_version %}
The version of the browser used by the device.
{% enddocs %}

{% docs column_device_id %}
The event's device ID. Device details can be viewed by joining the devices table.
{% enddocs %}

{% docs column_device_operating_system %}
The operating system installed on the device.
{% enddocs %}

{% docs column_event_seq_num_desc %}
The sequence number for the type of event described in this this table in descending order. The latest information for this event type is located at event_seq_num_desc = 1.
{% enddocs %}

{% docs column_device_type %}
The type of the device the user used.
{% enddocs %}

{% docs column_device_user_agent %}
The device's user agent.
{% enddocs %}

{% docs column_element_definition_id %}
The element definition of ID of the configured element in FullStory.
{% enddocs %}

{% docs column_event_time %}
The time the event was created.
{% enddocs %}

{% docs column_event_type %}
The type of event that occured.
{% enddocs %}

{% docs column_full_session_id %}
The device id + the session id. This is the unique identifier seen in the URL of Session Replay within app.fullstory.com.
{% enddocs %}

{% docs column_geo_city %}
The city the device appeared to be in.
{% enddocs %}

{% docs column_geo_country %}
The country the device appeared to be in.
{% enddocs %}

{% docs column_geo_ip_address %}
The IP address this user, device or session.
{% enddocs %}

{% docs column_geo_lat_long %}
The approximate latitude and longitude of the device.
{% enddocs %}

{% docs column_geo_region %}
The region (state if in the US) the device appeared to be in.
{% enddocs %}

{% docs column_initial_referrer_full_url %}
The fully qualified URL of the page that referred the current page.
{% enddocs %}

{% docs column_initial_referrer_hash_path %}
The path part of the hash part of the `initial_referrer_full_url`.
{% enddocs %}

{% docs column_initial_referrer_hash_query %}
The query part of the hash part of the `initial_referrer_full_url`.
{% enddocs %}

{% docs column_initial_referrer_host %}
The host part of the `initial_referrer_full_url`.
{% enddocs %}

{% docs column_initial_referrer_path %}
The path part of the `initial_referrer_full_url`.
{% enddocs %}

{% docs column_initial_referrer_query %}
The query part of the `initial_referrer_full_url`.
{% enddocs %}

{% docs column_last_device_browser %}
The last browser seen for this user, device or session.
{% enddocs %}

{% docs column_last_device_browser_version %}
The last browser version seen for this user, device or session.
{% enddocs %}

{% docs column_last_device_id %}
The last device ID seen for this user or session.
{% enddocs %}

{% docs column_last_event_id %}
The last unique event ID to occur for this user, device or session.
{% enddocs %}

{% docs column_last_event_time %}
The last time an event occured for this user, device or session.
{% enddocs %}

{% docs column_last_geo_city %}
The last city seen for this user, device or session.
{% enddocs %}

{% docs column_last_geo_country %}
The last country seen for this user, device or session.
{% enddocs %}

{% docs column_last_geo_ip_address %}
The last IP address seen for this user, device or session.
{% enddocs %}

{% docs column_last_geo_lat_long %}
The last latitude and longitude seen for this user, device or session.
{% enddocs %}

{% docs column_last_geo_region %}
The last region seen for this user, device or session.
{% enddocs %}

{% docs column_last_device_operating_system %}
The last operating system seen for this user, device or session.
{% enddocs %}

{% docs column_last_device_type %}
The last type of the device seen for this user, device or session.
{% enddocs %}

{% docs column_last_device_user_agent %}
The last user agent to be seen for this user, device or session.
{% enddocs %}

{% docs column_processed_time %}
The time the event was processed by FullStory internal systems.
{% enddocs %}

{% docs column_session_id %}
The unique ID corresponding to a single session. Devices can have many sessions. Users can have many sessions. Sessions have many events.
{% enddocs %}

{% docs column_source_type %}
The source of the session, web, mobile or server.
{% enddocs %}

{% docs column_target_masked %}
Whether or not the target is masked by a privacy rule.
{% enddocs %}

{% docs column_target_raw_selector %}
The raw CSS selector that points to the target element.
{% enddocs %}

{% docs column_target_text %}
The text of the target that the event was dispatched from.
{% enddocs %}

{% docs column_updated_time %}
The time the event was last updated. An event may be updated when more information about what happened in the browser arrives at the server.
{% enddocs %}

{% docs column_url_full_url %}
The fully qualified URL which the event occured on.
{% enddocs %}

{% docs column_url_hash_path %}
The path inside the hash portion of the URL.
{% enddocs %}

{% docs column_url_hash_query %}
The query inside the hash portion of the URL.
{% enddocs %}

{% docs column_url_host %}
The host part of the URL.
{% enddocs %}

{% docs column_url_path %}
The path part of the URL.
{% enddocs %}

{% docs column_url_query %}
The query part of the URL.
{% enddocs %}

{% docs column_user_display_name %}
The user's name that was used as part of an identify call.
{% enddocs %}

{% docs column_user_email %}
The email address that was used as part of an identify call.
{% enddocs %}

{% docs column_user_id %}
The unique ID corresponding to a single user. Not all sessions have an identified user.
{% enddocs %}

{% docs column_user_properties %}
The JSON properties that were sent via an identify call or setUserVars call.
{% enddocs %}

{% docs column_view_id %}
The unique ID corresponding to a single load of FS.js. A session may have many views.
{% enddocs %}

