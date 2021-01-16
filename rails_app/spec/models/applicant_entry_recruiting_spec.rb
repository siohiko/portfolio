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

  shared_examples_for "create Model" do |model, count|
    it { expect{subject}.to change(model, :count).by(count) }
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

      it 'delete unapproved entry' do
        expect(ApplicantEntryRecruiting.find_by(id: verified_applicant_entry_recruiting.id)).to eq nil
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
  #   callback   #
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

  describe 'destroy callback' do

    context 'decrease_participants_numbers_and_update_status method' do
      let(:recruiting) { create(:valid_recruiting, :recruiting_is_filled) }
      let(:entry) {recruiting.reload.applicant_entry_recruitings[0]}
      before { recruiting.reload }
      subject { entry.destroy }

      it 'status of recruiting update to open' do
        subject
        expect(recruiting.reload.status).to eq 'open'
      end
    end


    context 'create_delete_entry_notice method' do
      context 'when a member leaves' do
        let(:recruiting) { create(:valid_recruiting, :recruiting_is_filled) }
        let(:entry) {recruiting.reload.applicant_entry_recruitings[0]}
        before { entry.delete_reason = 'decline' }
        subject { entry.destroy }

        it 'save delete_entry_notice to owner' do
          subject
          notice = DeleteEntryNotice.first
          expect(notice.title).to eq '参加メンバーが離脱しました'
          expect(notice.user_id).to eq recruiting.user_id
        end

        it_behaves_like "create Model", DeleteEntryNotice, 1
      end


      context 'when owner deny the application' do
        let(:recruiting) { create(:valid_recruiting, :recruiting_with_applicant) }
        let(:entry) {recruiting.reload.applicant_entry_recruitings[0]}
        before { entry.delete_reason = 'refusal' }
        subject { entry.destroy }

        it 'save delete_entry_notice to owner' do
          subject
          notice = DeleteEntryNotice.first
          expect(notice.title).to eq '参加申請が拒否されました'
          expect(notice.user_id).to eq entry.applicant_id
        end

        it_behaves_like "create Model", DeleteEntryNotice, 1
      end


      context 'when owner kicks member' do
        let(:recruiting) { create(:valid_recruiting, :recruiting_is_filled) }
        let(:entry) {recruiting.reload.applicant_entry_recruitings[0]}
        before { entry.delete_reason = 'kick' }
        subject { entry.destroy }

        it 'save delete_entry_notice to owner' do
          subject
          notice = DeleteEntryNotice.first
          expect(notice.title).to eq 'キックされました'
          expect(notice.user_id).to eq entry.applicant_id
        end

        it_behaves_like "create Model", DeleteEntryNotice, 1
      end
    end

  end


  describe 'notification related callbacks ' do

    context 'when create new applicant_entry_recruiting' do
      subject { 
        entry = ApplicantEntryRecruiting.new(
          applicant_id: applicant.user_id,
          entry_recruiting_id: recruiting.id,
          message: 'よろしくお願いします。'
        )
        entry.save
      }

      let(:recruiting) { create(:valid_recruiting) }
      let(:applicant) { create(:valid_users) }

      it_behaves_like "create Model", ApplicationNotice, 1
      it 'notice incude message' do
        subject
        expect(ApplicationNotice.first.content).to eq 'よろしくお願いします。'
      end
    end


    context 'when update status to approved' do
      let(:recruiting) { create(:valid_recruiting, :recruiting_with_applicant) }
      subject { recruiting.applicant_entry_recruitings[0].approved! }

      it_behaves_like "create Model", AdoptionNotice, 1
    end



  end

end
