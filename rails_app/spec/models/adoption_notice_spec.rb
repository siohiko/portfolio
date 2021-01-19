# == Schema Information
#
# Table name: notices
#
#  id                      :bigint           not null, primary key
#  content                 :text
#  reason_for_delete_entry :integer          default(0), not null
#  status                  :integer          default("unread"), not null
#  title                   :string
#  type                    :string           not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  applicant_id            :string
#  recruiting_id           :integer
#  user_id                 :string
#
# Indexes
#
#  index_notices_on_user_id  (user_id)
#
require 'rails_helper'

RSpec.describe AdoptionNotice, type: :model do
  # ===================== #
  #      examples_for     #
  # ===================== #
  subject(:model_valid) { verified_adoption_notice.valid? }

  shared_examples_for "is valid" do
    it { model_valid; expect(verified_adoption_notice).to be_valid}
  end

  shared_examples_for "is invalid" do
    it { model_valid; expect(verified_adoption_notice).to be_invalid}
  end

  shared_examples_for "include error message" do |msg, symbol|
    it { model_valid; expect(verified_adoption_notice.errors[symbol]).to include msg }
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
      let(:verified_adoption_notice) { build(:valid_adoption_notice) }
      it_behaves_like "is valid"
    end


    context 'without recruiting_id' do
      let(:verified_adoption_notice) { build(:valid_adoption_notice) }
      before { verified_adoption_notice.recruiting_id = nil}
      it_behaves_like "is invalid"
    end

  end 



end
