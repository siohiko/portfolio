class FavoriteWeapon < ApplicationRecord
  belongs_to :apex_profile
  belongs_to :weapon
end
