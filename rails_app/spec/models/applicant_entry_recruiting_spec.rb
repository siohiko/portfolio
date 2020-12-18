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
      expect(ApplicantEntryRecruiting.first.status).to eq 'invited'
    end

  end

end
