# frozen_string_literal: true

module ::Jobs
  class AssignGroupBasedTitles < ::Jobs::Scheduled
    every SiteSetting.update_title_frequency.hours

    def execute(args)
      return unless SiteSetting.add_title_by_group_trust_enabled

      rules = SiteSetting.group_based_title_rules
      
      # Safety check: ensure 'rules' is an array before calling .each on it.
      # This directly addresses the error from the log.
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
