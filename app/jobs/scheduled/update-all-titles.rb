# frozen_string_literal: true

module AddTitleBasedOnTrustLevel
  class UpdateTitles < ::Jobs::Scheduled
    every SiteSetting.update_title_frequency.hours

    def execute(args)
      group_titles = JSON.parse(SiteSetting.group_trust_level_titles || "{}")

      User.find_each do |user|
        group_id = user.primary_group_id
        next unless group_id

        group = Group.find_by(id: group_id)
        next unless group

        group_key = group.name.downcase
        tl = user.trust_level

        titles = group_titles[group_key]
        next unless titles.is_a?(Array)
        next unless tl >= 1 && tl <= 4

        new_title = titles[tl]
        next unless new_title.present?

        user.update_column(:title, new_title)
      end
    end
  end
end
