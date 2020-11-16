require 'rails_helper'

RSpec.describe "UserAuthentications", type: :request do
  let(:valid_user) { create(:valid_user) }
  let(:valid_user_params) { attributes_for(:valid_user) }
  let(:invalid_user_id_params) { attributes_for(:invalid_user_id_user) }
  let(:invalid_password_params) { attributes_for(:invalid_password_user) }

  describe 'POST #create' do
    context '適切なパラメーターのケース' do
      it '登録成功' do
        post user_registration_path, params: { user: valid_user_params }
        expect(response.status).to eq 302
      end

      it 'createが成功すること' do
        expect do
          post user_registration_path, params: { user: valid_user_params }
        end.to change(User, :count).by 1
      end
    end

    context '不適切なパラメータ user_idが不適切な場合' do
      it 'リクエストが成功すること' do
        post user_registration_path, params: { user: invalid_user_id_params }
        expect(response.status).to eq 200
      end

      it 'createが失敗すること' do
        expect do
          post user_registration_path, params: { user: invalid_user_id_params }
        end.to_not change(User, :count)
      end

      it 'エラーが表示されること' do
        post user_registration_path, params: { user: invalid_user_id_params }
        expect(response.body).to include 'prohibited this user from being saved'
      end
    end

    context '不適切なパラメータ passwordが不適切な場合' do
      it 'リクエストが成功すること' do
        post user_registration_path, params: { user: invalid_password_params }
        expect(response.status).to eq 200
      end

      it 'createが失敗すること' do
        expect do
          post user_registration_path, params: { user: invalid_password_params }
        end.to_not change(User, :count)
      end

      it 'エラーが表示されること' do
        post user_registration_path, params: { user: invalid_password_params }
        expect(response.body).to include 'prohibited this user from being saved'
      end
    end

  end
end