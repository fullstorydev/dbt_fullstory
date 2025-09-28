# dbt_fullstory Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.10.0] - 2025-09-28

### Added

- **New intermediate model `int_events__windowed`** - Separates expensive window functions from staging model for improved performance
- **Enhanced JSON parsing capabilities** - Added `get_data_types_in_relation` macro for dynamic data type detection
- **Variable-driven configuration system** - Added support for `fullstory_enable_safe_json_parsing`, `fullstory_enable_data_tests`, and `fullstory_test_store_failures` variables
- **Comprehensive test configurations** - Added project-level test configurations with variable controls
- **Enhanced documentation** - Improved staging model documentation with detailed column descriptions

### Changed

- **Performance optimization in `events` model** - Replaced `dbt_utils.star` with explicit column listing for better query performance
- **Improved JSON parsing robustness** - Enhanced `json_value` and `parse_json_into_columns` macros with safer error handling and BigQuery JSON type compatibility
- **Restructured model dependencies** - Updated intermediate models (`int_events__devices`, `int_events__identifies`, `int_events__sessions`) to use `int_events__windowed` instead of `stg_fullstory__events`
- **Enhanced dbt project configuration** - Added structured configuration with performance optimizations, tagging, and layer-specific materializations
- **Staging model simplification** - Moved window functions from `stg_fullstory__events` to dedicated intermediate model

### Fixed

- **BigQuery JSON parsing errors** - Resolved "No matching signature for function PARSE_JSON" errors by properly handling JSON vs STRING data types
- **Window function performance** - Isolated expensive window operations to ephemeral intermediate model to improve overall pipeline performance
- **Safe JSON parsing** - Added SAFE.PARSE_JSON usage when `fullstory_enable_safe_json_parsing` is enabled for better error resilience

### Technical Details

- All changes maintain backward compatibility with existing downstream dependencies
- The `events` model output schema remains unchanged
- Performance improvements achieved through ephemeral materialization of window functions
- Enhanced error handling provides more robust data pipeline execution

## [0.9.4] - 2025-09-25

- **Fix events incremental model** - Events model was not parsing its incremental loading correctly.

## [0.9.3] - 2025-07-23

- **Add incremental model support to events** - The `events.sql` model now supports incremental loading. Please check the `README.md` file for details on how to enable incremental loading.

## [0.9.2] - 2025-07-21

- **Coalesce updated_time in staging model** - Fullstory data stored in object storage (i.e. S3, GCS, or Azure Blob Storage), may not have an `updated_time` value and is nullable on those destinations. Therefore the `updated_time` column will be coalesced with `processed_time` within the `stg_fullstory__events` model.

## [0.9.1] - 2025-05-28

- **Add deduplication of events in downstream fact models** - Due to the possibility of duplicate events in the underlying events table, this change will remove any duplicate events.

## [0.9.0] - 2025-03-10

### 🚨 Breaking Changes 🚨

- **Customers with incremental loading enabled** - Due to the upgrades in the incremental loading strategy, upgrading `dbt_fullstory` to `0.2.x` will break existing runs. Please run `dbt run --full-refresh` or `dbt build --full-refresh` first. Subsequent incremental loads will be substantially quicker.
- The `view_id`, `device_id`, and `session_id` columns are now strictly casted from **integer** to **varchar/string** data types. This may affect downstream uses.

### Fixed

- Incremental models that require a event_time adjustment via the `fullstory_incremental_interval_hours` variable now have a cleaner implementation. A Jinja variable named `incremental_adjustment` will be used in its place.
- All final models, (e.g. `sessions.sql`), have a lineage with an intermediate model.
- Incremental models will both reference a time-adjusted `event_time` and `updated_time` to handle late-arriving events and updated events.

### Added

- Added intermediate dbt models to leverage DRY development patterns
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
