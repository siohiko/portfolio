# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
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