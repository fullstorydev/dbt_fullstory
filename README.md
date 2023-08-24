# The Official FullStory dbt Package for Data Destinations
This dbt package contains models, macros, seeds, and tests for [FullStory](https://www.fullstory.com/)'s [Data Destinations](https://help.fullstory.com/hc/en-us/articles/6295300682903-Data-Destinations) add-on.

## Models
| model | description |
| - | - |
| sessions | Session-level aggregations, including event counts broken down by type, location and device information, duration, FullStory session replay links, etc.
| users | User-level aggregations, including email addresses, location and device information, session counts, etc.

## Supported Warehouses
- BigQuery
- Snowflake

## Quick Start
To deploy or update this package in your warehouse, follow these steps:
- Clone this project: `git clone https://github.com/fullstorydev/dbt_fullstory.git && cd ./dbt_fullstory`
- Create a new profile called `dbt_fullstory` in `~/.dbt/profiles.yml`. You can find instructions for this step for [BigQuery](https://docs.getdbt.com/docs/core/connect-data-platform/bigquery-setup) and [Snowflake](https://docs.getdbt.com/docs/core/connect-data-platform/snowflake-setup) in the official dbt documentaion.
- Install dependencies, seed, and run: `dbt deps && dbt seed && dbt run`

### Example Profile Configurations
#### BigQuery
```yaml
dbt_fullstory:
  target: fullstory_data_destinations
  outputs:
    staging:
      # The project and dataset should match Data Destinations settings
      # configured within FullStory
      type: bigquery
      method: oauth
      project: my-gcp-project
      dataset: my_dataset
      threads: 1
```

#### SnowFlake
```yaml
dbt_fullstory:
  target: fullstory_data_destinations
  outputs:
    staging:
      # The account, database, and warehouse should match Data Destinations
      # settings configured within FullStory. The schema is automatically
      # created in your warehouse the first time FullStory syncs data. The
      # user, password, and role should have permission to create objects
      # within the specified schema.
      type: snowflake
      account: xy12345.us-east-1.aws
      user: my_admin_user
      password: ********
      role: my_admin_role
      database: fullstory
      warehouse: compute_wh
      schema: fullstory_o_abcd_na1
      threads: 1
      client_session_keep_alive: False
      query_tag: [fullstory_dbt]
```

## Installation
General information about dbt packages can be found [here](https://docs.getdbt.com/docs/build/packages).

### Requirements
- dbt version >= 1.6.0
- FullStory Data Destination events table
  - In BigQuery, this table will be named `fullstory_events_o_123_na1`.
  - In Snowflake, this table will be named `events`.
  - The events table will be created the first time that FullStory syncs event data to your warehouse.

### Adding to an Existing Project
Include the following into your packages.yml file:

```yaml
  - git: fullstorydev/dbt_fullstory
    revision: 0.1.0
```

Then, run `dbt deps` to install the package. We highly recommend pinning to a specific release. Pinning your version helps prevent unintended changes to your warehouse.
