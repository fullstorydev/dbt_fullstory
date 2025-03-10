# dbt_fullstory Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-03-10
## 🚨 Breaking Change 🚨
- **Customers with incremental loading enabled** - Due to the upgrades in the incremental loading strategy, upgrading `dbt_fullstory` to `0.2.x` will break exisiting runs. Please run `dbt run --full-refresh` or `dbt build --full-refresh` firstly. Subsequent incremental loads will be substantially quicker.
### Fixed
- Incremental models that require a event_time adjustment via the `fullstory_incremental_interval_hours` variable now have a cleaner implementation. A Jinja variable named `incremental_adjustment` will be used in its place.
- All final models, (e.g. `sessions.sql`), have a lineage with an intermediate model.
- Incremental models will both reference a time-adjusted `event_time` and `updated_time` to handle late-arriving events and updated events.
### Added
- Added intermediate DBT models to leverage DRY development patterns
- `devices`, `display_names`, `identified_users` and `sessions` all handle incremental loading
- `schema.yml` - all dbt model configuration and documentations found in a single folder will now be handled in one file for simplicity.
### Changed
- `stg_fullstory__events.sql` materialization is now a `view`, this is due to its repeated use.
- `anonymous_users.sql` - improved removal of `device_id` from the `identifies` model.
- `events.sql` and `identifies.sql` - materialization is now a `view`. This reduces waste on a minorly transformed `fullstory_events_[id]` source table.
- `identified_users.sql` - styling improvements
- `sessions.sql` and upstream models - improved DAG that improves performance and reduces data warehouse load.
## [0.8.x] - Inception to 2025-03-10
All `dbt_fullstory` development prior to `CHANGELOG.md` being added
