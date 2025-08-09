# ... (plugin header)
enabled_site_setting :add_title_by_group_trust_enabled

after_initialize do
  require_relative "./app/jobs/scheduled/update-all-titles.rb"
end
