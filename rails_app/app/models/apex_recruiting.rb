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

end