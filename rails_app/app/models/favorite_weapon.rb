# == Schema Information
#
# Table name: favorite_weapons
#
#  id              :bigint           not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  apex_profile_id :integer
#  weapon_id       :integer
#
# Indexes
#
#  index_favorite_weapons_on_apex_profile_id  (apex_profile_id)
#  index_favorite_weapons_on_weapon_id        (weapon_id)
#
class FavoriteWeapon < ApplicationRecord
  belongs_to :apex_profile
  belongs_to :weapon
end
