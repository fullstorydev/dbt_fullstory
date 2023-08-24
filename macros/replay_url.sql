{% macro get_replay_url_path() -%}
    'https://{{ var("fullstory_replay_host") }}/ui/{{ target.name }}/session/'
{%- endmacro %}
