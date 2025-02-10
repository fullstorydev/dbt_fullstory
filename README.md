# The Official Fullstory dbt Package for Data Destinations
This dbt package contains models, macros, seeds, and tests for [Fullstory](https://www.fullstory.com/)'s [Data Destinations](https://help.fullstory.com/hc/en-us/articles/6295300682903-Data-Destinations) add-on.

## Models
| model | description |
| - | - |
| anonymous_users | All users that have not been identified. |
| devices | All events with their device information parsed. |
| events | All events (incremental materialization possible) |
| identified_users | All users who have been identified. |
| identities | All identify events. |
| sessions | Session-level aggregations, including event counts broken down by type, location and device information, duration, Fullstory session replay links, etc.
| users | User-level aggregations, including email addresses, location and device information, session counts, etc.

## Vars
| var | description |
| - | - |
| fullstory_events_database | The database where your Fullstory events table lives. |
| fullstory_events_schema | The schema inside of your database where your Fullstory events table lives. |
| fullstory_events_table | The name of the table inside your schema where your Fullstory events table lives. |
| fullstory_replay_host | The hostname to use when building links to session replay. |
| fullstory_sessions_model_name | The name of the model for the canonical list of sessions. |
| fullstory_anonymous_users_model_name | The customized name of the `anonymous_users` model. |
| fullstory_devices_model_name | The customized name of the `devices`` model. |
| fullstory_events_model_name | The customized name of the `events`` model. |
| fullstory_identified_users_model_name | The customized name of the `identified_users` model. |
| fullstory_identities_model_name | The customized name of the `identities`` model. |
| fullstory_sessions_model_name | The customized name of the `sessions`` model. |
| fullstory_skip_json_parse | Whether or not to skip JSON parsing when processing the data, default False. |
| fullstory_users_model_name | The customized name of the `users`` model. |
| fullstory_min_event_time | All events before this date will not be considered for analysis. Use this option to limit table size. |
| fullstory_event_types | A list of event types to auto-generate rollups for in the `users` and `sessions` model. |

> We **highly recommend** using `fullstory_events_database`, `fullstory_events_schema` and `fullstory_events_table` to indicate the location of the Fullstory events table that is synced from Data Destinations. Using these variables allow you to use a separate database or schema for the Fullstory events table than your dbt package.

#### Example use of vars for Big Query
```yaml
vars:
  fullstory_events_database: my-gcp-project
  fullstory_events_schema: my-big-query-dataset
  fullstory_events_table: fullstory_events_[my-org-id]
```

#### Example use of vars for Snowflake
```yaml
vars:
  fullstory_events_database: my_database
  fullstory_events_schema: my_schema
  fullstory_events_table: my_table
```

#### Example use of vars for Redshift or Redshift Serverless
```yaml
vars:
  fullstory_events_database: my_database
  fullstory_events_schema: my_schema
  fullstory_events_table: my_table
```

## Supported Warehouses
- BigQuery
- Snowflake
- Redshift
- Redshift Serverless

### Example Profile Configurations
#### BigQuery
```yaml
dbt_fullstory:
  target: prod
  outputs:
    prod:
      type: bigquery
      method: oauth
      project: my-gcp-project
      dataset: my_dataset
      threads: 1
```

#### Snowflake
```yaml
dbt_fullstory:
  target: prod
  outputs:
    prod:
      type: snowflake
      account: xy12345.us-east-1.aws
      user: my_admin_user
      password: ********
      role: my_admin_role
      database: fullstory
      warehouse: compute_wh
      schema: my_schema
      threads: 1
      client_session_keep_alive: False
      query_tag: [fullstory_dbt]
```

#### Redshift
```yaml
dbt_fullstory:
  target: prod
  outputs:
    prod:
      type: redshift
      cluster_id: my-cluster-id
      method: iam
      host: my-cluster-id.12345678910.us-east-1.redshift.amazonaws.com
      port: 5439
      user: admin
      iam_profile: my-aws-profile
      dbname: dev
      schema: dbt
      region: us-east-1
      threads: 8
      connect_timeout: 30
```

#### Redshift Serverless
```yaml
dbt_fullstory:
  target: prod
  outputs:
    prod:
      type: redshift
      cluster_id: my-namespace-id
      method: iam
      host: my-workgroup.12345678910.us-east-1.redshift-serverless.amazonaws.com
      port: 5439
      user: serverlessuser
      iam_profile: my-aws-profile
      dbname: dev
      schema: dbt
      region: us-east-1
      threads: 8
      connect_timeout: 30
```

## Installation
General information about dbt packages can be found [here](https://docs.getdbt.com/docs/build/packages).

### Requirements
- dbt version >= 1.6.0
- Fullstory Data Destination events table
  - In BigQuery, this table will be named `fullstory_events_o_123_na1` where `o-123-na1` is your org id.
    - Your org ID can be found in the URL when logged into fullstory.
    ```
    app.fullstory.com/ui/<your-org-id>/...
    ```
  - In Snowflake, this table will be named `events`.
  - The events table will be created the first time that Fullstory syncs event data to your warehouse.

### Adding to an Existing Project
Include the following into your packages.yml file:

```yaml
  - package: fullstorydev/dbt_fullstory
    revision: 0.6.0
```

Then, run `dbt deps` to install the package. We highly recommend pinning to a specific release. Pinning your version helps prevent unintended changes to your warehouse.

To use the seed tables which have some info around common types, run:
```sh
dbt seed
```

## Incremental modeling

DBT provides a powerful mechanism for improving the performance of your models and reducing query costs: [incremental models](https://docs.getdbt.com/docs/build/incremental-models). An incremental model only processes new or updated records since the last run, thereby saving significant processing power and time.

> If you are running DBT on a regular interval, be aware that `dbt run` will take longer to run with the incremental materialization than with a view materialization.

In this package, it is important to start with the incrementalization of the `events` model, since it functions as an activity log and is an ancestor to all models in this package.

### Getting started with incremental models

You can configure your project to load the `events` table from this package incrementally. All you need to do is add a configuration block for the `dbt_fullstory` project under the `models` key in your `dbt_project.yml`:

```yaml
# Configuring models
# Full documentation: https://docs.getdbt.com/docs/configuring-models
models:
  ...

  dbt_fullstory: # The package name you are customizing
    events: # The model name
      materialized: incremental
      unique_key: event_id
      # The following options are Big Query specific optimizations. For specific configuration options for your warehouse see: https://docs.getdbt.com/reference/model-configs#warehouse-specific-configurations
      +partition_by: 
        field: event_time
        data_type: timestamp
        granularity: day
      cluster_by:
        - device_id
    sessions: # The model name
      materialized: incremental
      unique_key: full_session_id
      # The following options are Big Query specific optimizations. For specific configuration options for your warehouse see: https://docs.getdbt.com/reference/model-configs#warehouse-specific-configurations
      +partition_by: 
        field: updated_time
        data_type: timestamp
        granularity: day
      cluster_by:
        - user_id
```

When loading data incrementally, DBT needs to know how far back to look in the current table for data to compare to the incoming data. We will look back 2 days for data to update by default. This interval can be configured with the variable `fullstory_incremental_interval` and should be specified as a SQL interval like `INTERVAL 2 DAY`.

Two days was decided upon because we typically drop late arriving events after 24 hours. To understand why a event may arrive late, please check out [this article on swan songs](https://help.fullstory.com/hc/en-us/articles/360048109714-Swan-songs-How-Fullstory-captures-sessions-that-end-unexpectedly#:~:text=If%20the%20user%20navigates%20away,Fullstory%20before%20the%20page%20closes.).

This incremental interval is important; it can limit the cost of a query by greatly reducing the amount of work that needs to be done in order to add new data. Ultimatley, this setting will be specific to your needs; we recommend starting with the default and updating once you understand the trends of your data set.

### Considerations

- **Use incrementally-loaded models judiciously:** While incremental loading does improve performance and cut costs, it adds some complexity to managing your dbt project. Ensure you need the trade-off before implementing it.

- **Aggregation challenges:** Aggregations in incrementally-loaded models can be challenging and unreliable. When performing aggregations (such as count, sum, average), best practice is to refresh the complete model to include all data in the aggregation. Incrementally updating aggregated data can yield incorrect results because of missing or partially updated data. 

Think about whether using date-partitioned tables, continuous rollups (using window functions), or occasionally running full-refreshes might serve your use case better.

Remember, fine tuning model performance and costs is a balancing act. Incremental models may not suit all scenarios, but when managed correctly, they can be incredibly powerful. Start with the `events` model, measure the benefits, and then increment other models as necessary. Happy modeling!

### Other models
Although, we often find the incrementalization of the `events` model to be sufficient, you can customize the materialization method of any model in this package. Enabling additional incrementalization can be done in the same way as the `events` table, simply add a configuration block to your `dbt_project.yml`.

## Running Integration Tests
The `integration_tests` directory is a DBT project itself that depends on `dbt_fullstory`. We use this package to test how our models will execute in the real world as it simulates a live environment and is used in CI to hit actual databases. If you wish, you can run these tests locally. All you need is a target configured in your `profiles.yml` that is authenticated to a supported warehouse type.

> Internally, we name our profiles after the type of warehouse we are connecting (e.g. `bigquery`, `snowflake`, etc.). It makes the command more clear, like: `dbt run --target bigquery`.

To create the test data in your database:
```
dbt seed --target my-target
```

To run the shim for your warehouse:
> The shim will emulate how data is synced for your particular warehouse. As an example, data is loaded in JSON columns in Snowflake but as strings in BigQuery. You can choose from:
> - bigquery_events_shim
> - snowflake_events_shim
```
dbt run --target my-target --select <my-warehouse>_events_shim 
```

To run the models:
```
dbt run --target my-target
```

To run the tests:
```
dbt test --target my-target
```
