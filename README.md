# README
[![siohiko](https://circleci.com/gh/siohiko/portfolio.svg?style=svg)](https://app.circleci.com/pipelines/github/siohiko/portfolio)
## 概要
一緒にゲーム（現状Apex Legendsのみ）をプレイする人を見つけるWEBアプリケーションです。  
URL：[NOLABO](http://nolabo-portfolio.tk/)
### テストユーザー
下記IDとパスワードでテストユーザーとしてログインしてお試しできます。
|ID  | PASSWORD |
|---|---|
|test_user  |testpass  |
|test_user2  |testpass2  |

### 使用の流れ

1. 登録する
2. 基本プロフィール、ゲームプロフィール（Apex Legends）を設定する
3. 募集する
4. 通知にて参加申請を確認する 
5. 参加申請を承認する
6. 募集ページのチャットでやりとりをして一緒にゲームをプレイ
## 使用技術
- Ruby 2.6.3
- Ruby on Rails 6.0.3
- Vue.js
- SCSS
- PostgreSQL 11
- Nginx
- Puma
- AWS
  - EC2
  - VPC
- Docker
- Docker-compose
- CircleCi
- Rspec
## 実装した機能一覧
- ユーザー登録機能
- ログイン機能
- ユーザープロフィール編集機能
- ゲームプロフィール編集機能
- 参加メンバー募集機能
- 参加申請機能
- 募集検索機能
- 参加申請、参加承認等の通知機能
- 参加メンバー専用のコメント機能

## 主な使用gem
- devise
  - ユーザー登録、ログイン、プロフィール編集機能周りに使用
- kaminari
  - 募集検索ページのページネーションに使用
- bullet
  - N + 1問題検知
- dotenv-rails
  - 環境変数設定に使用

## 開発環境セットアップ
リポジトリをローカルにクローンしたら下記手順でセットアップできます。
1. master.keyを設定
2. setupコマンドを叩く  
```$ ./bin/setup init```  

