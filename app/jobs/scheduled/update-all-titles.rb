module ::AddTitleByGroupTrust
  class UpdateTitles < ::Jobs::Scheduled
    every SiteSetting.update_title_frequency.hours

    def execute(args)
      return unless SiteSetting.add_title_by_group_trust_enabled

      mappings = JSON.parse(SiteSetting.group_trust_level_titles || '{}')

      # 遍历每组规则，构造 SQL CASE WHEN 批量赋值
      User.transaction do
        mappings.each do |group_key, titles|
          next unless titles.is_a?(Array)

          (1...titles.size).each do |tl|
            title = titles[tl]
            next if title.blank?

            # 找到对应 primary_group 且 trust_level 匹配 的用户
            group = Group.find_by("LOWER(name) = ?", group_key.downcase)
            next unless group

            # 只批量给普通用户赋值
            User.where(primary_group_id: group.id, trust_level: tl, admin: false, moderator: false)
                .where.not(title: title)
                .update_all(title: title)
          end
        end
      end
    end
  end
end
