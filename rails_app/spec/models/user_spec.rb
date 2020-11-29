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

end
