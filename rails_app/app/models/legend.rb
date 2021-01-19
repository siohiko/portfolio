# == Schema Information
#
# Table name: legends
#
#  id         :bigint           not null, primary key
#  icon_path  :string           not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Legend < ApplicationRecord
  has_many :favorite_legends
  has_many :apex_profiles, through: :favorite_legends
end
