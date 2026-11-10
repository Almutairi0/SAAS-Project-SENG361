require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.enable_reloading = true
  config.eager_load = false
  config.consider_all_requests_local = true
  config.server_timing = true
  config.cache_store = :null_store

  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  # Shows which line of code fired each SQL query (handy for spotting N+1)
  config.active_record.verbose_query_logs = true
  config.action_view.annotate_rendered_view_with_filenames = true
end
