# frozen_string_literal: true

module ::Jobs
  class UpdateTitlesByGroupTL < ::Jobs::Scheduled
    every 6.hours   # 定期执行，也可按需调整间隔

    def execute(args)
      mapping_json = SiteSetting.group_tl_to_title_map
      group_map = JSON.parse(mapping_json) rescue {}

      # 生成条件和title CASE语句
      sql_cases = []
      group_map.each do |group_name, tl_titles|
        next unless tl_titles.is_a?(Array)
        tl_titles.each_with_index do |title, tl|
          next if title.to_s.strip == ""
          sql_cases << <<~SQL
            WHEN users.primary_group_id = (SELECT id FROM groups WHERE name = '#{group_name}') AND users.trust_level = #{tl}
            THEN '#{title.gsub("'", "''")}'
          SQL
        end
      end

      return if sql_cases.empty?

      sql = <<~SQL
        UPDATE users
        SET title = CASE
          #{sql_cases.join("\n")}
          ELSE title
        END
        WHERE users.primary_group_id IS NOT NULL;
      SQL

      # 执行SQL
      DB.exec sql
    end
  end
end
