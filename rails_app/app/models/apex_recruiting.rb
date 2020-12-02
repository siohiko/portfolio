class ApexRecruiting < Recruiting


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