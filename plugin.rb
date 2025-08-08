# name: add-title-based-on-group-trust-level
# about: Assigns user titles based on primary group and trust level, per-site admin setting
# version: 0.1
# authors: your-name

enabled_site_setting :add_title_by_group_trust_enabled

after_initialize do
  # nothing here - all logic in the scheduled job
end
