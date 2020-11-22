require 'rails_helper'

# Items to be verified
# ・return the correct http status code
# ・being redirected to the correct page.
# ・contains a message that should be displayed in the view
# ・data increase or decrease correctly.

# Since it is the responsibility of the controller's internal implementation to ensure 
# that the correct object is stored in the response template, we won't test it here

RSpec.describe "DeviseUsersController", type: :request do

  # ===================== #
  # examples_for response #
  # ===================== #
  shared_examples_for "return http" do |code|
    it { subject; expect(response).to have_http_status(code)}
  end

  shared_examples_for "include error message" do |msg|
    it { subject; expect(response.body).to include msg }
  end

  shared_examples_for "redirect to root_path" do
    it { subject; expect(response).to redirect_to root_path }
  end
  
  shared_examples_for "redirect to login_path" do
    it { subject; expect(response).to redirect_to new_user_session_path }
  end

  shared_examples_for "redirect to registered_user_path" do
    it { subject; expect(response).to redirect_to user_path(registered_user.user_id) }
  end

  # ================== #
  # examples_for model #
  # ================== #
  shared_examples_for "create Model" do |model|
    it { expect{subject}.to change(model, :count).by(1) }
  end

  shared_examples_for "Failing to create Model" do |model|
    it { expect{subject}.to_not change(model, :count) }
  end

  # It's the model's responsibility to make sure the values are changed correctly, so we won't test it here.
  shared_examples_for "update Model" do |model|
    it { expect{subject}.to change{model.count}.by(0) }
  end





  # ============= #
  # create action #
  # ============= #
  describe 'POST devise/registrations#create' do
    subject { post user_registration_path, params: { user: params }}

    context 'with valid params' do
      let(:params) { attributes_for(:valid_user) }

      it_behaves_like "return http", 302
      it_behaves_like "create Model", User
      it "redirect user_path"do 
        subject
        expect(response).to redirect_to user_path(params[:user_id])
      end
    end


    context 'with invalid params : blank user_id case' do
      let(:params) { attributes_for(:valid_user, user_id: "") }

      it_behaves_like "return http", 200
      it_behaves_like "Failing to create Model", User
      it_behaves_like "include error message", 'ID を入力してください'
    end


    context 'with invalid params : blank password case' do
      let(:params) { attributes_for(:valid_user, password: "") }
      
      it_behaves_like "return http", 200
      it_behaves_like "Failing to create Model", User
      it_behaves_like "include error message", 'パスワード は8文字以上で入力してください'
    end

    context 'with invalid params : short password case' do
      let(:params) { attributes_for(:valid_user, password: "hoge") }
      
      it_behaves_like "return http", 200
      it_behaves_like "Failing to create Model", User
      it_behaves_like "include error message", 'パスワード は8文字以上で入力してください'
    end

  end



  # ============= #
  # edit action #
  # ============= #
  describe 'GET devise/registrations#edit' do
    subject { get edit_user_registration_path }
    let(:registered_user) { create(:valid_user) }

    context 'case of Logged in' do
      before { sign_in registered_user }

      it_behaves_like "return http", 200
    end

    context 'case of being not Logged in' do
      it_behaves_like "return http", 302
      it_behaves_like "redirect to login_path"
    end

  end



  # ============= #
  # update action #
  # ============= #
  describe 'PUT devise/registrations#update' do
    subject { put user_registration_path, params: { user: params }}
    let(:registered_user) { create(:valid_user) }

    context 'case of Logged in' do
      before { sign_in registered_user }

      context 'with valid params' do
        before { registered_user_id = registered_user.user_id }
        let(:params) { attributes_for(:valid_user, name: "valid_user_name", sex: 1, age: 25) }

        it_behaves_like "return http", 302
        it_behaves_like "redirect to registered_user_path"
        it 'updates user' do
          subject
          registered_user.reload
          expect(registered_user.name).to eq params[:name]
          expect(registered_user.sex).to eq params[:sex]
          expect(registered_user.age).to eq params[:age]
        end
      end


      context 'with invalid params : user_id case' do
        let(:params) { attributes_for(:valid_user, user_id: "", name: "valid_user_name", sex: 1, age: 25) }
        
        it_behaves_like "return http", 200
        it_behaves_like "include error message", 'ID を入力してください'
        it 'failure to updates user' do
          subject
          registered_user.reload
          expect(registered_user.name).not_to eq params[:name]
          expect(registered_user.sex).not_to eq params[:sex]
          expect(registered_user.age).not_to eq params[:age]
        end
      end
      
    end


    context 'case of being not Logged in' do
      let(:params) { attributes_for(:valid_user, name: "valid_user_name", sex: 1, age: 25) }

      it_behaves_like "return http", 302
      it_behaves_like "redirect to login_path"
    end

  end



  # ============= #
  # destroy action #
  # ============= #
  describe 'DELETE devise/registrations#destroy' do
    subject { delete user_registration_path }
    let(:registered_user) { create(:valid_user) }

    context 'case of Logged in' do
      before { sign_in registered_user }

      it "delete user" do
         expect{subject}.to change(User, :count).by(-1) 
      end

    end

    context 'case of being not Logged in' do
      it_behaves_like "return http", 302
      it_behaves_like "redirect to login_path"
    end

  end

end