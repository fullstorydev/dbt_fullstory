# The Official FullStory dbt Package for Data Destinations
This dbt package contains models, macros, seeds, and tests for [FullStory](https://www.fullstory.com/)'s [Data Destinations](https://help.fullstory.com/hc/en-us/articles/6295300682903-Data-Destinations) add-on.

## Models
| model | description |
| - | - |
| sessions | Session-level aggregations, including event counts broken down by type, location and device information, duration, FullStory session replay links, etc.
| users | User-level aggregations, including email addresses, location and device information, session counts, etc.

## Vars
| var | description |
| - | - |
| fullstory_events_database | The database where your FullStory events table lives. |
| fullstory_events_schema | The schema inside of your database where your FullStory events table lives. |
| fullstory_events_table | The name of the table inside your schema where your FullStory events table lives. |
| fullstory_replay_host | The hostname to use when building links to session replay. |
| fullstory_sessions_model_name | The name of the model for the canonical list of sessions. |
| fullstory_users_model_name | The name of the model for the canonical list of users. |
| fullstory_min_event_time | All events before this date will not be considered for analysis. Use this option to limit table size. |
| fullstory_event_types | A list of event types to auto-generate rollups for in the `users` and `sessions` model. |

> We **highly recommend** using `fullstory_events_database`, `fullstory_events_schema` and `fullstory_events_table` to indicate the location of the FullStory events table that is synced from Data Destinations. Using these variables allow you to use a separate database or schema for the FullStory events table than your dbt package.

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

## Supported Warehouses
- BigQuery
- Snowflake

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

#### SnowFlake
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

## Installation
General information about dbt packages can be found [here](https://docs.getdbt.com/docs/build/packages).

### Requirements
- dbt version >= 1.6.0
- FullStory Data Destination events table
  - In BigQuery, this table will be named `fullstory_events_o_123_na1` where `o-123-na1` is your org id.
    - Your org ID can be found in the URL when logged into fullstory.
    ```
    app.fullstory.com/ui/<your-org-id>/...
    ```
  - In Snowflake, this table will be named `events`.
  - The events table will be created the first time that FullStory syncs event data to your warehouse.

### Adding to an Existing Project
Include the following into your packages.yml file:

```yaml
  - package: fullstorydev/dbt_fullstory
    revision: 0.2.0
```

Then, run `dbt deps` to install the package. We highly recommend pinning to a specific release. Pinning your version helps prevent unintended changes to your warehouse.

To use the seed tables which have some info around common types, run:
```sh
dbt seed
```

## Incremental modeling

DBT provides a powerful mechanism for improving the performance of your models and reducing query costs: [incremental models](https://docs.getdbt.com/docs/build/incremental-models). An incremental model only processes new or updated records since the last run, thereby saving significant processing power and time. 

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
```

When loading data incrementally, DBT needs to know how far back to look in the current table for data to compare to the incoming data. We will look back 7 days for data to update by default. This interval can be configured with the variable `fullstory_incremental_interval` and should be specified as a SQL interval like `INTERVAL 7 DAY`.

This incremental interval is important; it can limit the cost of a query by greatly reducing the amount of work that needs to be done in order to add new data. Ultimatley, this setting will be specific to your needs; we recommend starting with the default and updating once you understand the trends of your data set.

### Considerations

- **Use incrementally-loaded models judiciously:** While incremental loading does improve performance and cut costs, it adds some complexity to managing your dbt project. Ensure you need the trade-off before implementing it.

- **Aggregation challenges:** Aggregations in incrementally-loaded models can be challenging and unreliable. When performing aggregations (such as count, sum, average), best practice is to refresh the complete model to include all data in the aggregation. Incrementally updating aggregated data can yield incorrect results because of missing or partially updated data. 

Think about whether using date-partitioned tables, continuous rollups (using window functions), or occasionally running full-refreshes might serve your use case better.

Remember, fine tuning model performance and costs is a balancing act. Incremental models may not suit all scenarios, but when managed correctly, they can be incredibly powerful. Start with the `events` model, measure the benefits, and then increment other models as necessary. Happy modeling!

### Other models
Although, we often find the incrementalization of the `events` model to be sufficient, you can customize the materialization method of any model in this package. Enabling additional incrementalization can be done in the same way as the `events` table, simply add a configuration block to your `dbt_project.yml`.
