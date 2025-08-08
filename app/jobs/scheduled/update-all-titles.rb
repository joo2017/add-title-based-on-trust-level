# frozen_string_literal: true

module ::AddTitleByGroupTrust
  class UpdateTitlesByGroupTrust < ::Jobs::Scheduled
    every SiteSetting.add_title_by_group_trust_frequency.hours

    def execute(args)
      titles_config = SiteSetting.group_trust_level_titles
      return unless titles_config.present?
      begin
        rules = JSON.parse(titles_config)
      rescue JSON::ParserError => e
        Rails.logger.error("add-title plugin: JSON parse error in group_trust_level_titles: #{e.message}")
        return
      end

      User.where.not(primary_group_id: nil).find_each do |user|
        next if user.admin? || user.moderator?

        group = Group.find_by(id: user.primary_group_id)
        next unless group
        group_key = group.name.downcase
        tl = user.trust_level.to_i

        tl_titles = rules[group_key]
        next unless tl_titles.is_a?(Array)
        next unless tl > 0 && tl < tl_titles.length
        new_title = tl_titles[tl]
        next if !new_title.present? || user.title == new_title

        user.update_column(:title, new_title)
      end
    end
  end
end
