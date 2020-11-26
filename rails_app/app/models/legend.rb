class Legend < ApplicationRecord
  has_many :favorite_legends
  has_many :apex_profiles, through: :favorite_legends
end
