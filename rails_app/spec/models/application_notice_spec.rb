# == Schema Information
#
# Table name: notices
#
#  id         :bigint           not null, primary key
#  content    :text
#  status     :integer
#  title      :string
#  type       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :string
#
# Indexes
#
#  index_notices_on_user_id  (user_id)
#
require 'rails_helper'

RSpec.describe ApplicationNotice, type: :model do
  # ===================== #
  #      examples_for     #
  # ===================== #
  subject(:model_valid) { verified_application_notice.valid? }

  shared_examples_for "is valid" do
    it { model_valid; expect(verified_application_notice).to be_valid}
  end

  shared_examples_for "is invalid" do
    it { model_valid; expect(verified_application_notice).to be_invalid}
  end

  shared_examples_for "include error message" do |msg, symbol|
    it { model_valid; expect(verified_application_notice.errors[symbol]).to include msg }
  end


  # ================== #
  # examples_for model #
  # ================== #
  shared_examples_for "create Model" do |model, count|
    it { expect{subject}.to change(model, :count).by(count) }
  end



  # ============= #
  #    validate   #
  # ============= #
  describe 'about validate' do

    context 'with valid params ' do
      let(:verified_application_notice) { build(:valid_application_notice) }
      it_behaves_like "is valid"
    end

    context 'without applicant_id' do
      let(:verified_application_notice) { build(:valid_application_notice) }
      before { verified_application_notice.applicant_id = nil}
      it_behaves_like "is invalid"
    end

    context 'without recruiting_id' do
      let(:verified_application_notice) { build(:valid_application_notice) }
      before { verified_application_notice.recruiting_id = nil}
      it_behaves_like "is invalid"
    end

  end 



end
