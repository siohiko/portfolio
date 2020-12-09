require 'rails_helper'

RSpec.describe ApexProfile, type: :model do

  # ===================== #
  #      examples_for     #
  # ===================== #
  subject(:model_valid) { verified_apex_profile.valid? }

  shared_examples_for "is valid" do
    it { model_valid; expect(verified_apex_profile).to be_valid}
  end

  shared_examples_for "is invalid" do
    it { model_valid; expect(verified_apex_profile).to be_invalid}
  end


  # ============= #
  #    validate   #
  # ============= #
  # notice: no test for enum.

  describe 'about validate' do
    
    context 'with valid params ' do
      let(:verified_apex_profile) { build(:valid_apex_profile) }
      it_behaves_like "is valid"
    end

    context 'already been created' do
      let(:created_apex_profile) { create(:valid_apex_profile) }
      let(:verified_apex_profile) { build(:valid_apex_profile) }
      before { 
        created_apex_profile
        verified_apex_profile
      }
      
      it_behaves_like "is invalid"
    end

    context 'without user_id' do
      let(:verified_apex_profile) { build(:valid_apex_profile, user_id: nil) }
      it_behaves_like "is invalid"
    end


  end



  # ============= #
  #    relation   #
  # ============= #

  describe 'about relation' do
    
    #Legent models are not tested because they do not manipulate data.
    context 'edit favorite legends' do
      let(:verified_apex_profile) { create(:valid_apex_profile) }
      let(:valid_legend) { create(:wraith) }
      before { 
        verified_apex_profile
        valid_legend
      } 

      it 'add favorite legend model' do 
        expect{ verified_apex_profile.legends << valid_legend }.to change{ FavoriteLegend.all.count }.from(0).to(1)
      end
    end


    context 'edit favorite weapons' do
      let(:verified_apex_profile) { create(:valid_apex_profile) }
      let(:valid_weapon) { create(:g7) }
      before { 
        verified_apex_profile
        valid_weapon
      } 

      it 'add favorite weapon model' do 
        expect{ verified_apex_profile.weapons << valid_weapon }.to change{ FavoriteWeapon.all.count }.from(0).to(1)
      end
    end


    context 'delete user' do
      let(:verified_apex_profile) { create(:valid_apex_profile) }
      before { verified_apex_profile }

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