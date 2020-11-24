require 'rails_helper'

RSpec.describe ApexProfile, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"

  # ===================== #
  #      examples_for     #
  # ===================== #
  subject(:model_valid) { verified_apex_profile.valid? }

  shared_examples_for "is valid" do
    it { model_valid; expect(verified_apex_profile).to be_valid}
  end

  # ============= #
  #    validate   #
  # ============= #

  describe 'validate' do
    before { create(:valid_user) }
    
    context 'with valid params ' do
      let(:verified_apex_profile) { build(:valid_apex_profile) }
      it_behaves_like "is valid"
    end

  end



  # ============= #
  #    relation   #
  # ============= #

  describe 'relation' do
    
    
    context 'delete user' do
      let(:verified_apex_profile) { create(:valid_apex_profile) }

      before {
        verified_apex_profile
      }

      it 'delete apex_profile too' do 
        count = ApexProfile.all.count
        verified_apex_profile.user.destroy
        expect(ApexProfile.all.count).to eq (count - 1)
      end
    end

  end




  # ============= #
  #    method   #
  # ============= #

  describe 'rank(enum)' do
    before { create(:valid_user) }
    let(:verified_apex_profile) { build(:valid_apex_profile, rank: rank) }
    where(:rank, :return_value) do
      [
        [nil, nil],
        [0, 'ブロンズ'],
        [1, 'シルバー'],
        [2, 'ゴールド'],
        [3, 'プラチナ'],
        [4, 'ダイヤ'],
        [5, 'マスター'],
        [6, 'プレデター']
      ]
    end

    with_them do
      it 'return valid value' do 
        expect(verified_apex_profile.rank).to eq return_value
      end
    end  
  end

  
  describe 'platform(enum)' do
    before { create(:valid_user) }
    let(:verified_apex_profile) { build(:valid_apex_profile, platform: platform) }
    where(:platform, :return_value) do
      [
        [nil, nil],
        [0, 'PC'],
        [1, 'PS4'],
        [2, 'XBOX'],
      ]
    end

    with_them do
      it 'return valid value' do 
        expect(verified_apex_profile.platform).to eq return_value
      end
    end  
  end

end
