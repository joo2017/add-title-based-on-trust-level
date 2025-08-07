# frozen_string_literal: true

# name: add-title-based-on-trust-level
# about: TODO
# meta_topic_id: TODO
# version: 1.1.0
# authors: NateDhaliwal
# url: https://github.com/NateDhaliwal/add-title-based-on-trust-level
# required_version: 2.7.0

enabled_site_setting :add_title_based_on_trust_level_enabled

module ::AddTitleBasedOnTrustLevel
  PLUGIN_NAME = "add-title-based-on-trust-level"
end

#require_relative "lib/add_title_based_on_trust_level/engine"



after_initialize do
  %w[
    ../app/jobs/scheduled/update-all-titles.rb
  ].each { |path| require File.expand_path(path, __FILE__) }
  
  # tl0_title = SiteSetting.tl0_title_on_create
  # tl1_title = SiteSetting.tl1_title_on_promotion
  # tl2_title = SiteSetting.tl2_title_on_promotion
  # tl3_title = SiteSetting.tl3_title_on_promotion
  # tl4_title = SiteSetting.tl4_title_on_promotion
  # # User.where(trust_level: 0).update_all(title: tl0_title)
  # # User.where(trust_level: 1).update_all(title: tl1_title)
  # # User.where(trust_level: 2).update_all(title: tl2_title)
  # # User.where(trust_level: 3).update_all(title: tl3_title)
  # # User.where(trust_level: 4).update_all(title: tl4_title)
  
  # on(:user_created) do |newuserdata|
  #   newuserid = newuserdata[:user_id]
  #   newuser = User.find_by(id: newuserid)
    
  #   if newuser.trust_level == 0 then
  #     newuser.title = tl0_title
  #     newuser.save!
  #   elsif newuser.trust_level == 1 then
  #     newuser.title = tl1_title
  #     newuser.save!
  #   elsif newuser.trust_level == 2 then
  #     newuser.title = tl2_title
  #     newuser.save!
  #   elsif newuser.trust_level == 3 then
  #     newuser.title = tl3_title
  #     newuser.save!
  #   elsif newuser.trust_level == 4 then
  #     newuser.title = tl4_title
  #     newuser.save!
  #   end
  # end
  
  # on(:user_promoted) do |userdata|
  #   userid = userdata[:user_id]
  #   user = User.find_by(id: userid)
  #   tl0_title = SiteSetting.tl0_title_on_create
  #   tl1_title = SiteSetting.tl1_title_on_promotion
  #   tl2_title = SiteSetting.tl2_title_on_promotion
  #   tl3_title = SiteSetting.tl3_title_on_promotion
  #   tl4_title = SiteSetting.tl4_title_on_promotion
  #   if user.trust_level == 0 then
  #     user.title = tl0_title
  #     user.save!
  #   elsif user.trust_level == 1 then
  #     user.title = tl1_title
  #     user.save!
  #   elsif user.trust_level == 2 then
  #     user.title = tl2_title
  #     user.save!
  #   elsif user.trust_level == 3 then
  #     user.title = tl3_title
  #     user.save!
  #   elsif user.trust_level == 4 then
  #     user.title = tl4_title
  #     user.save!
  #   end
  # end
end
