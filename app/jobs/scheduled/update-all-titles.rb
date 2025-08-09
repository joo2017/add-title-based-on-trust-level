# frozen_string_literal: true

module ::Jobs
  # 我们重命名一下任务类，让它和插件名更匹配
  class AssignGroupBasedTitles < ::Jobs::Scheduled
    every SiteSetting.update_title_frequency.hours

    def execute(args)
      # 检查总开关是否开启
      return unless SiteSetting.add_title_by_group_trust_enabled

      # Discourse会直接给我们一个结构清晰的规则对象数组，不再需要JSON.parse
      rules = SiteSetting.group_based_title_rules
      return if rules.blank?

      # 使用数据库事务来确保所有操作要么全部成功，要么全部失败，保证数据安全
      User.transaction do
        # 遍历管理员在后台设置的每一条规则
        rules.each do |rule|
          # 从规则对象中直接读取数据，非常清晰
          group_id = rule["group_id"]
          trust_level = rule["trust_level"]
          title = rule["title"]

          # 如果规则不完整，则跳过
          next if group_id.blank? || trust_level.blank? || title.blank?

          # 找到所有符合这条规则的用户
          # （主群组匹配、信任等级匹配、且当前头衔不是我们想设置的那个）
          # 然后批量将他们的头衔更新为规则中指定的头衔
          User.where(primary_group_id: group_id, trust_level: trust_level)
              .where.not(title: title)
              .update_all(title: title)
        end
      end
    end
  end
end
