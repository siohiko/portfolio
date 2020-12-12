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

end
