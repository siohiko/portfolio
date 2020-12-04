require 'rails_helper'

#don't test recruiting class
RSpec.describe ApexRecruiting, type: :model do
  # ===================== #
  #      examples_for     #
  # ===================== #
  subject(:model_valid) { verified_apex_recruiting.valid? }

  shared_examples_for "is valid" do
    it { model_valid; expect(verified_apex_recruiting).to be_valid}
  end


  # ============= #
  #    validate   #
  # ============= #
  describe 'about validate' do
    
    context 'with valid params ' do
      let(:verified_apex_recruiting) { build(:valid_apex_recruiting) }
      it_behaves_like "is valid"
    end
  end



  # ============= #
  #    scope   #
  # ============= #
  describe 'rank_is' do
    let(:created_valid_apex_recruiting) { create(:valid_apex_recruiting) }
    before { created_valid_apex_recruiting }

    it 'return valid value' do 
      expect(ApexRecruiting.rank_is(created_valid_apex_recruiting.rank)[0].rank).to eq created_valid_apex_recruiting.rank
    end
  end


  describe 'game_mode_is' do
    let(:created_valid_apex_recruiting) { create(:valid_apex_recruiting) }
    before { created_valid_apex_recruiting }

    it 'return valid value' do 
      expect(ApexRecruiting.game_mode_is(created_valid_apex_recruiting.game_mode)[0].game_mode).to eq created_valid_apex_recruiting.game_mode
    end
  end


  # ============= #
  #    method   #
  # ============= #
  describe 'rank(enum)' do
    let(:verified_apex_recruiting) { build(:valid_apex_recruiting, rank: rank) }
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
        expect(verified_apex_recruiting.rank).to eq return_value
      end
    end  
  end

  
  describe 'game_mode(enum)' do
    let(:verified_apex_recruiting) { build(:valid_apex_recruiting, game_mode: game_mode) }
    where(:game_mode, :return_value) do
      [
        [nil, nil],
        [0, 'カジュアル'],
        [1, 'ランク'],
        [2, 'どちらでも']
      ]
    end

    with_them do
      it 'return valid value' do 
        expect(verified_apex_recruiting.game_mode).to eq return_value
      end
    end  
  end

end
