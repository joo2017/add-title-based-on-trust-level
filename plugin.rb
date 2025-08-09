# frozen_string_literal: true

# name: add-title-by-group-trust-level
# about: Assign titles based on primary group and trust level.
# version: 2.0.0
# authors: Your Name

# 确保插件的总开关设置正确
enabled_site_setting :add_title_by_group_trust_enabled

# 这是最关键的一步：在Discourse初始化后加载我们的定时任务文件
after_initialize do
  # 使用 require_relative 来安全地加载位于同一插件目录下的文件
  require_relative "./app/jobs/scheduled/update-all-titles.rb"
end
