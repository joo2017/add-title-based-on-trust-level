# frozen_string_literal: true

module ::Jobs
  class AssignGroupBasedTitles < ::Jobs::Scheduled
    every SiteSetting.update_title_frequency.hours

    def execute(args)
      return unless SiteSetting.add_title_by_group_trust_enabled

      # 获取设置值，它现在是一个JSON字符串
      rules_json_string = SiteSetting.group_based_title_rules
      return if rules_json_string.blank?

      begin
        # 这是最关键的修复：手动将JSON字符串解析成Ruby数组
        rules = JSON.parse(rules_json_string)
      rescue JSON::ParserError
        # 如果JSON格式错误，则直接退出，防止任务失败
        Rails.logger.error("Group-Based Titles Plugin: Failed to parse group_based_title_rules JSON.")
        return
      end
      
      return unless rules.is_a?(Array) && rules.present?

      User.transaction do
        rules.each do |rule|
          group_id = rule["group_id"]
          trust_level = rule["trust_level"]
          title = rule["title"]

          next if group_id.blank? || trust_level.blank? || title.blank?

          User.where(primary_group_id: group_id, trust_level: trust_level)
              .where.not(title: title)
              .update_all(title: title)
        end
      end
    end
  end
end
