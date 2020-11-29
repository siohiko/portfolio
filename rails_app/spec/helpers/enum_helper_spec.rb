require 'rails_helper'

RSpec.describe EnumHelper, type: :helper do


  #ToDo: Dependence on ApexProfileClass
  describe "options_for_select_from_enum" do
    it "return array of enum" do
      expect(options_for_select_from_enum(ApexProfile, 'rank')).to eq(
        [
          ["ブロンズ","ブロンズ"],
          ["シルバー","シルバー"],
          ["ゴールド","ゴールド"],
          ["プラチナ","プラチナ"],
          ["ダイヤ","ダイヤ"],
          ["マスター","マスター"],
          ["プレデター","プレデター"]
        ]
      )
    end
  end

end
