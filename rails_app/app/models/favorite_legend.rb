# == Schema Information
#
# Table name: favorite_legends
#
#  id              :bigint           not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  apex_profile_id :integer
#  legend_id       :integer
#
# Indexes
#
#  index_favorite_legends_on_apex_profile_id  (apex_profile_id)
#  index_favorite_legends_on_legend_id        (legend_id)
#
class FavoriteLegend < ApplicationRecord
  belongs_to :apex_profile
  belongs_to :legend
end
