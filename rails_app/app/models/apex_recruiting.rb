# == Schema Information
#
# Table name: recruitings
#
#  id                  :bigint           not null, primary key
#  comment             :text
#  game_mode           :integer
#  play_style          :text
#  rank                :integer
#  recruitment_numbers :integer
#  status              :integer          default("open"), not null
#  type                :string           not null
#  vc                  :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  user_id             :string(32)       not null
#
class ApexRecruiting < Recruiting

  scope :rank_is,       -> (rank){ where(rank: rank) if rank.present? }
  scope :game_mode_is,       -> (game_mode){ where(game_mode: game_mode) if game_mode.present? }

  enum rank: { 
    "ブロンズ": 0,
    "シルバー": 1,
    "ゴールド": 2,
    "プラチナ": 3,
    "ダイヤ": 4,
    "マスター": 5,
    "プレデター": 6
  }


  enum game_mode: { 
    "カジュアル": 0,
    "ランク": 1,
    "どちらでも": 2
  }

  class << self

    def search(params)
      return self.status_open.rank_is(params[:search][:rank]).game_mode_is(params[:search][:game_mode])
    end

  end
end
