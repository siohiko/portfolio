# == Schema Information
#
# Table name: applicant_entry_recruitings
#
#  id                  :bigint           not null, primary key
#  status              :integer          default("unapproved")
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  applicant_id        :string(32)       not null
#  entry_recruiting_id :integer          not null
#
# Indexes
#
#  index_applicant_entry_recruitings_on_applicant_id         (applicant_id)
#  index_applicant_entry_recruitings_on_entry_recruiting_id  (entry_recruiting_id)
#
require 'rails_helper'

RSpec.describe ApplicantEntryRecruiting, type: :model do
  # ===================== #
  #      examples_for     #
  # ===================== #
  subject(:model_valid) { verified_applicant_entry_recruiting.valid? }

  shared_examples_for "is valid" do
    it { model_valid; expect(verified_applicant_entry_recruiting).to be_valid}
  end

  shared_examples_for "is invalid" do
    it { model_valid; expect(verified_applicant_entry_recruiting).to be_invalid}
  end

  shared_examples_for "include error message" do |msg, symbol|
    it { model_valid; expect(verified_applicant_entry_recruiting.errors[symbol]).to include msg }
  end


  # ============= #
  #    validate   #
  # ============= #
  # notice: no test for enum.

  describe 'about validate' do

    context 'if the recruiting has already been closed' do
      let(:applying_user) { build(:applying_user, :user_with_entry_recruiting) }
      let(:verified_applicant_entry_recruiting) {applying_user.applicant_entry_recruiting}

      before { 
        applying_user
        applying_user.entry_recruiting.status = 'close'
      }
      it_behaves_like "is invalid"
      it_behaves_like "include error message", 'その募集は既に閉じられています', 'entry_recruiting'.to_sym
    end


    context 'if the applicant is owner' do
      let(:applying_user) { build(:applying_user, :user_with_entry_recruiting) }
      let(:verified_applicant_entry_recruiting) {applying_user.applicant_entry_recruiting}

      before { 
        applying_user
        verified_applicant_entry_recruiting.applicant_id = applying_user.entry_recruiting.user_id
      }
      it_behaves_like "is invalid"
      it_behaves_like "include error message", 'あなた自身がかけた募集には応募できません', 'applicant'.to_sym
    end


    context 'if the number of participants exceeds recruitment_numbers at the time of update' do
      let(:recruiting) { create(:valid_recruiting, :recruiting_with_applicant, recruitment_numbers: 1) }
      let(:verified_applicant_entry_recruiting) { recruiting.applicant_entry_recruitings[0] }
      let(:participant_entry) { recruiting.applicant_entry_recruitings[1] }

      before { participant_entry.approved! }

      it 'return errors' do
        verified_applicant_entry_recruiting.reload.update(status: 'approved')
        expect(verified_applicant_entry_recruiting.errors[:status]).to include 'この募集は既に満員です。募集人数を設定しなおしてください。'
      end
    end

  end

  # ============= #
  #    relation   #
  # ============= #
  describe 'about relation' do

    context 'when delete user' do
      let(:applying_user) { create(:applying_user, :user_with_entry_recruiting) }
      before { applying_user }

      it 'delete applicant_entry_recruiting too' do 
        count = ApplicantEntryRecruiting.all.count
        applying_user.destroy
        expect(ApplicantEntryRecruiting.all.count).to eq (count - 1)
      end
    end


    context 'when delete recruiting' do
      let(:applying_user) { create(:applying_user, :user_with_entry_recruiting) }
      before { applying_user }

      it 'delete applicant_entry_recruiting too' do 
        count = ApplicantEntryRecruiting.all.count
        applying_user.entry_recruiting.destroy
        expect(ApplicantEntryRecruiting.all.count).to eq (count - 1)
      end
    end

  end


  # ============ #
  #    method    #
  # ============ #
  describe 'status(enum)' do
    let(:applying_user) { create(:applying_user, :user_with_entry_recruiting) }
    before { applying_user }

    it 'return valid value' do
      expect(ApplicantEntryRecruiting.first.status).to eq 'unapproved'
    end

  end



  # ============ #
  #    callback  #
  # ============ #
  describe 'increase_participants_numbers_and_update_status method' do
    let(:recruiting) { create(:valid_recruiting, :recruiting_with_applicant) }
    let(:verified_applicant_entry_recruiting) { recruiting.applicant_entry_recruitings[0] }
    let(:participant_entry) { recruiting.applicant_entry_recruitings[1] }
    before { 
      participant_entry.approved!
    }

    it 'return valid value' do
      verified_applicant_entry_recruiting.reload.approved!
      expect(recruiting.reload.status).to eq 'filled'
    end

  end

  describe 'destrou callback' do
    let(:recruiting) { create(:valid_recruiting, :recruiting_is_filled) }
    before { recruiting.reload }

    it 'return valid value' do
      recruiting.applicant_entry_recruitings[0].destroy
      expect(recruiting.reload.status).to eq 'open'
    end

  end

end
