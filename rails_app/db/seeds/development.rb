User.create(user_id: 'tanaka', password: 'password')
User.create(user_id: 'suzuki', password: 'password')
User.create(user_id: 'seki', password: 'password')
User.create(user_id: 'takahashi', password: 'password')
User.create(user_id: 'kawakamai', password: 'password')
User.create(user_id: 'katou', password: 'password')
User.create(user_id: 'ninja', password: 'password')
User.create(user_id: 'tom', password: 'password')
User.create(user_id: 'bob', password: 'password')


Recruiting.create(type: 'ApexRecruiting', user_id: 'tanaka',    vc: 'on', recruitment_numbers: '2', status: 'open', rank: 'ブロンズ', game_mode: 'ランク')
Recruiting.create(type: 'ApexRecruiting', user_id: 'suzuki',    vc: 'on', recruitment_numbers: '2', status: 'open', rank: 'ブロンズ', game_mode: 'カジュアル')
Recruiting.create(type: 'ApexRecruiting', user_id: 'seki',      vc: 'on', recruitment_numbers: '2', status: 'open', rank: 'シルバー', game_mode: 'ランク')
Recruiting.create(type: 'ApexRecruiting', user_id: 'takahashi', vc: 'on', recruitment_numbers: '2', status: 'open', rank: 'シルバー', game_mode: 'ランク')
Recruiting.create(type: 'ApexRecruiting', user_id: 'kawakamai', vc: 'on', recruitment_numbers: '2', status: 'open', rank: 'ゴールド', game_mode: 'カジュアル')
Recruiting.create(type: 'ApexRecruiting', user_id: 'katou',     vc: 'on', recruitment_numbers: '2', status: 'open', rank: 'プラチナ', game_mode: 'カジュアル')
Recruiting.create(type: 'ApexRecruiting', user_id: 'ninja',     vc: 'on', recruitment_numbers: '2', status: 'open', rank: 'プラチナ', game_mode: 'ランク')
Recruiting.create(type: 'ApexRecruiting', user_id: 'tom',       vc: 'on', recruitment_numbers: '2', status: 'open', rank: 'プラチナ', game_mode: 'ランク')
Recruiting.create(type: 'ApexRecruiting', user_id: 'bob',       vc: 'on', recruitment_numbers: '2', status: 'open', rank: 'ダイヤ'  , game_mode: 'ランク')


Legend.create(name: 'オクタン', icon_path: 'octane')
Legend.create(name: 'クリプト', icon_path: 'crypto')
Legend.create(name: 'コースティック', icon_path: 'caustic')
Legend.create(name: 'ジブラルタル', icon_path: 'gibraltar')
Legend.create(name: 'バンガロール', icon_path: 'bangalore')
Legend.create(name: 'パスファインダー', icon_path: 'pathfinder')
Legend.create(name: 'ブラッドハウンド', icon_path: 'bloodhound')
Legend.create(name: 'ホライゾン', icon_path: 'horizon')
Legend.create(name: 'ミラージュ', icon_path: 'mirage')
Legend.create(name: 'ライフライン', icon_path: 'lifeline')
Legend.create(name: 'ランパート', icon_path: 'rampart')
Legend.create(name: 'レイス', icon_path: 'wraith')
Legend.create(name: 'レブナント', icon_path: 'revenant')
Legend.create(name: 'ローバ', icon_path: 'loba')
Legend.create(name: 'ワットソン', icon_path: 'wattson')

#category
#0:アサルトライフル
#1:サブマシンガン
#2:ライトマシンガン
#3:スナイパーライフル
#4:ショットガン
#5:ピストル

Weapon.create(name: 'フラットライン', category: 0)
Weapon.create(name: 'G7スカウト', category: 0)
Weapon.create(name: 'ヘムロック', category: 0)
Weapon.create(name: 'R-301', category: 0)
Weapon.create(name: 'ハボック', category: 0)
Weapon.create(name: 'オルタネーター', category: 1)
Weapon.create(name: 'R-99', category: 1)
Weapon.create(name: 'プラウラー', category: 1)
Weapon.create(name: 'ボルト', category: 1)
Weapon.create(name: 'ディヴォーション', category: 2)
Weapon.create(name: 'スピットファイア', category: 2)
Weapon.create(name: 'L-スター', category: 2)
Weapon.create(name: 'ロングボウ', category: 3)
Weapon.create(name: 'クレーバー', category: 3)
Weapon.create(name: 'トリプルテイク', category: 3)
Weapon.create(name: 'センチネル', category: 3)
Weapon.create(name: 'チャージライフル', category: 3)
Weapon.create(name: 'EVA-8オート', category: 4)
Weapon.create(name: 'ピースキーパー', category: 4)
Weapon.create(name: 'マスティフ', category: 4)
Weapon.create(name: 'モザンビーク', category: 4)
Weapon.create(name: 'P2020', category: 5)
Weapon.create(name: 'RE-45', category: 5)
Weapon.create(name: 'ウィングマン', category: 5)