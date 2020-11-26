require 'rails_helper'

RSpec.describe Weapon, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"


  # ============= #
  #    method   #
  # ============= #

  describe 'category(enum)' do
    let(:valid_weapon) { build(:valid_weapon, category: category) }
    where(:category, :return_value) do
      [
        [nil, nil],
        [0, 'アサルトライフル'],
        [1, 'サブマシンガン'],
        [2, 'ライトマシンガン'],
        [3, 'スナイパーライフル'],
        [4, 'ショットガン'],
        [5, 'ピストル']
      ]
    end

    with_them do
      it 'return valid value' do 
        expect(valid_weapon.category).to eq return_value
      end
    end  
  end

end
