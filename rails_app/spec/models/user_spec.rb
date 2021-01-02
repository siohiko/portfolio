# == Schema Information
#
# Table name: users
#
#  age                    :integer
#  encrypted_password     :string           default(""), not null
#  introduce              :text
#  name                   :string(16)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sex                    :integer          default("男性"), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  user_id                :string(32)       not null, primary key
#
# Indexes
#
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_user_id               (user_id) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do

  # ===================== #
  #      examples_for     #
  # ===================== #

  subject(:model_valid) { verified_user.valid? }

  shared_examples_for "is valid" do
    it { model_valid; expect(verified_user).to be_valid}
  end

  shared_examples_for "is invalid" do
    it { model_valid; expect(verified_user).not_to be_valid}
  end
  
  shared_examples_for "include error message" do |msg, symbol|
    it { model_valid; expect(verified_user.errors[symbol]).to include msg }
  end


  # ============= #
  #    validate   #
  # ============= #
  context 'with valid params ' do
    let(:verified_user) { build(:valid_user) }

    it_behaves_like "is valid"
  end


  context 'without user_id' do
    let(:verified_user) { build(:no_user_id) }

    it_behaves_like "is invalid"
    it_behaves_like "include error message", 'を入力してください', 'user_id'.to_sym
  end
  
  context 'without password' do
    let(:verified_user) { build(:no_password) }

    it_behaves_like "is invalid"
    it_behaves_like "include error message", 'は8文字以上で入力してください', 'password'.to_sym
  end


  context 'with duplicated user_id' do
    before { create(:valid_user) }
    let(:verified_user) { build(:valid_user) }

    it_behaves_like "is invalid"
    it_behaves_like "include error message", 'このIDは既に使われています', 'user_id'.to_sym
  end


  context 'with overly long user_id' do
    let(:verified_user) { build(:valid_user, user_id: 'a'*33) }
    it_behaves_like "is invalid"
    it_behaves_like "include error message", 'は32文字以下にしてください', 'user_id'.to_sym
  end

  context 'with overly long user_id' do
    let(:verified_user) { build(:valid_user, name: 'a'*17) }
    it_behaves_like "is invalid"
    it_behaves_like "include error message", 'は16文字以下にしてください', 'name'.to_sym
  end

  context 'with overly long introduce' do
    let(:verified_user) { build(:valid_user, introduce: 'a'*256) }
    it_behaves_like "is invalid"
    it_behaves_like "include error message", 'は255文字以下にしてください', 'introduce'.to_sym
  end




  # ============= #
  #    method     #
  # ============= #
  describe 'is_owner? method' do
    let(:valid_recruiter) { create(:recruiter, :user_with_recruiting) }
    let(:recruiting){ valid_recruiter.recruiting }
    let(:another_recruiting) { create(:valid_recruitings) }

    context 'with valid argument of recruiting' do
      it 'return true' do 
        expect(valid_recruiter.is_owner?(recruiting)).to eq true
      end
    end

    context 'with invalid argument of recruiting' do
      it 'return false' do 
        expect(valid_recruiter.is_owner?(another_recruiting)).to eq false
      end
    end
  end


  describe 'is_applicant? method' do
    let(:valid_recruiting) { create(:valid_recruiting, :recruiting_with_applicant) }
    let(:applicant){ valid_recruiting.applicants[0] }
    let(:another_recruiting) { create(:valid_recruitings) }

    context 'with valid argument of recruiting' do
      it 'return true' do 
        expect(applicant.is_applicant?(valid_recruiting)).to eq true
      end
    end

    context 'with invalid argument of recruiting' do
      it 'return false' do 
        expect(applicant.is_applicant?(another_recruiting)).to eq false
      end
    end
  end


  describe 'is_member? method' do
    let(:valid_recruiting) { create(:valid_recruiting, :recruiting_with_applicant) }
    let(:applicant){ valid_recruiting.applicants[0] }
    let(:another_recruiting) { create(:valid_recruitings) }

    before{
      applicant.applicant_entry_recruiting.approved!
    }

    context 'with valid argument of recruiting' do
      it 'return true' do 
        expect(applicant.is_member?(valid_recruiting)).to eq true
      end
    end

    context 'with invalid argument of recruiting' do
      it 'return false' do 
        expect(applicant.is_member?(another_recruiting)).to eq false
      end
    end
  end

  describe 'is_free? method' do
    let(:valid_recruiting) { create(:valid_recruiting, :recruiting_with_applicant) }
    let(:applicant){ valid_recruiting.applicants[0] }
    let(:another_user) { create(:valid_users) }

    before{
      applicant.applicant_entry_recruiting.approved!
    }

    context 'case of applicant' do
      it 'return false' do 
        expect(applicant.is_free?).to eq false
      end
    end

    context 'case of unapplicant' do
      it 'return true' do 
        expect(another_user.is_free?).to eq true
      end
    end
  end
end
