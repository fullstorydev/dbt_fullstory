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
| fullstory_events_database | The database where your raw events table lives. |
| fullstory_events_schema | The schema inside of your database where your raw events table lives. |
| fullstory_events_table | The name of the table inside your schema where your raw events table lives. |
| fullstory_replay_host | The hostname to use when building links to session replay. |
| fullstory_sessions_model_name | The name of the model for the canonical list of sessions. |
| fullstory_users_model_name | The name of the model for the canonical list of users. |
| fullstory_min_event_time | All events before this date will not be considered for analysis. Use this option to limit table size. |
| fullstory_event_types | A list of event types to auto-generate rollups for in the `users` and `sessions` model. |

> We **highly recommend** using `fullstory_events_database`, `fullstory_events_schema` and `fullstory_events_table` to indicate the location of the raw events table that is synced from Data Destinations. Using these variables allow you to use a separate database or schema for the raw events table than your dbt package.

#### Example use of vars for Big Query
```yaml
vars:
  fullstory_events_database: my-gcp-project
  fullstory_events_schema: my-big-query-dataset
  fullstory_events_table: fullstory_events_[my-org-id]
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
