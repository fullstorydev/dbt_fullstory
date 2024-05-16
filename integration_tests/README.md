# The official Fullstory dbt package for integration testing
This dbt package contains the integration tests for the dbt_fullstory package. This project spoofs a Fullstory events table using a CSV file and the `dbt seeds` command.

## Setting up your warehouse
This dbt package deploys all the models and a fake events table to your warehouse. To do so, you will need a separate integrations test dataset/schema. **Do NOT use your production or staging environments. It needs to be a dedicated, separate dataset/schema for integration testing.**

You will need to add a new dbt profile target for integration testing like
```yaml
dbt_fullstory_integration_tests:
  target: integration_tests

  outputs:
    integration_tests:
      type: bigquery
      method: oauth

      # TODO: add these env vars to your machine
      project: "{{ env_var('DBT_ENV_BIGQUERY_PROJECT_TEST') }}"
      dataset: "{{ env_var('DBT_ENV_BIGQUERY_DATASET_TEST') }}" # TODO: Make a different dataset than your production/staging one

      threads: 4
      job_execution_timeout_seconds: 300
      job_retries: 1
      priority: interactive
```

## Running integration tests
1. Run `dbt seed -s fullstory_events_integration_tests` to update the test data
1. Run `dbt test` to run all tests or `dbt test -s test_sessions` for testing a specific model.

## Adding integration tests
1. Add your test event data `seeds/fullstory_events_integration_tests.csv`
    1. All event IDs must be unique. We've been using `<name of the test>_test_<event number>` like `sessions_total_event_counts_test_1`.
    1. Update your session + device ID so that they don't overlap with other tests. We key test data off of the session + device ID values.
    1. CSV row order doesn't *technically* matter to the dbt package, but it helps keep things clean for other devs that have to read the CSV file. CSV column order does matter here.
1. In the Mac "numbers" application, click File -> Export To -> CSV... -> Next button... (UTF8 is fine) -> Export button (replace seeds/fullstory_events_integration_tests.csv).
1. Author your dbt tests "like normal" in the YAML model file, like those in `_test_sessions.yml`, or similar.
