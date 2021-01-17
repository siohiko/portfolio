# == Schema Information
#
# Table name: comments
#
#  id            :bigint           not null, primary key
#  content       :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  recruiting_id :integer
#  user_id       :string
#
# Indexes
#
#  index_comments_on_recruiting_id  (recruiting_id)
#  index_comments_on_user_id        (user_id)
#
require 'rails_helper'

RSpec.describe Comment, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
