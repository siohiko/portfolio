# == Schema Information
#
# Table name: notices
#
#  id            :bigint           not null, primary key
#  content       :text
#  status        :integer
#  title         :string
#  type          :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  applicant_id  :string
#  recruiting_id :integer
#  user_id       :string
#
# Indexes
#
#  index_notices_on_user_id  (user_id)
#
require 'rails_helper'

RSpec.describe Notice, type: :model do
  # ===================== #
  #      examples_for     #
  # ===================== #
  subject(:model_valid) { verified_notice.valid? }

  shared_examples_for "is valid" do
    it { model_valid; expect(verified_notice).to be_valid}
  end

  shared_examples_for "is invalid" do
    it { model_valid; expect(verified_notice).to be_invalid}
  end

  shared_examples_for "include error message" do |msg, symbol|
    it { model_valid; expect(verified_notice.errors[symbol]).to include msg }
  end


  # ============= #
  #    validate   #
  # ============= #
  describe 'about validate' do

    context 'with valid params ' do
      let(:verified_notice) { build(:valid_notice) }
      it_behaves_like "is valid"
    end

    context 'with invalid type' do
      let(:verified_notice) { build(:valid_notice, type: 'InvalidType') }
      it_behaves_like "is invalid"
    end

    context 'with too much content' do
      let(:verified_notice) { build(:valid_notice, content: 'a'*256) }
      it_behaves_like "is invalid"
    end
  end

end
