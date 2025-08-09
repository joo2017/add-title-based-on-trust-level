# frozen_string_literal: true

# name: add-title-by-group-trust-level
# about: Assign titles based on primary group and trust level.
# version: 2.1.0
# authors: Your Name

enabled_site_setting :add_title_by_group_trust_enabled

after_initialize do
  require_relative "./app/jobs/scheduled/update-all-titles.rb"
end
