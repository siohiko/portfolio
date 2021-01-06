# == Schema Information
#
# Table name: applicant_entry_recruitings
#
#  id                  :bigint           not null, primary key
#  status              :integer          default("invited")
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


    context 'if the recruiting is filled' do
      let(:applying_user) { build(:applying_user, :user_with_entry_recruiting) }
      let(:verified_applicant_entry_recruiting) {applying_user.applicant_entry_recruiting}

      before { 
        applying_user
        applying_user.entry_recruiting.recruitment_numbers = 0
      }
      it_behaves_like "is invalid"
      it_behaves_like "include error message", 'その募集は既に満員です', 'entry_recruiting'.to_sym
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
  #   callback   #
  # ============ #
  describe 'update callback' do
    let(:applying_user) { create(:applying_user, :user_with_entry_recruiting) }
    let(:applying_user__applicant_entry_recruiting) {applying_user.applicant_entry_recruiting }
    let(:applying_user_entry_recruiting) { applying_user.entry_recruiting }
    before { applying_user }

    context 'case of updating status to approved' do
      it 'recruitment_numbers of Recruiting decrease' do
        expect{ applying_user__applicant_entry_recruiting.approved! }.to change{ applying_user_entry_recruiting.recruitment_numbers }.by(-1)
      end
    end

    context 'case of updating status to unapproved' do
      before { applying_user__applicant_entry_recruiting.approved! }
      it 'recruitment_numbers of Recruiting increase' do
        expect{ applying_user__applicant_entry_recruiting.unapproved! }.to change{ applying_user_entry_recruiting.recruitment_numbers }.by(1)
      end
    end
  end


  describe 'destroy callback' do
    let(:applying_user) { create(:applying_user, :user_with_entry_recruiting) }
    let(:applying_user__applicant_entry_recruiting) {applying_user.applicant_entry_recruiting }
    let(:applying_user_entry_recruiting) { applying_user.entry_recruiting }
    before { applying_user }

    context 'case of destroy applicant' do

      it 'recruitment_numbers of Recruiting remain the same' do
        expect{ applying_user__applicant_entry_recruiting.destroy }.to change{ applying_user_entry_recruiting.recruitment_numbers }.by(0)
      end
    end

    context 'case of destroy participant' do
      before { applying_user__applicant_entry_recruiting.approved! }
      it 'recruitment_numbers of Recruiting increase' do
        expect{ applying_user__applicant_entry_recruiting.destroy }.to change{ applying_user_entry_recruiting.recruitment_numbers }.by(1)
      end
    end
  end
end
