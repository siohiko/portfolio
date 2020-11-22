require 'rails_helper'

# Items to be verified
# ・return the correct http status code
# ・being redirected to the correct page.
# ・contains a message that should be displayed in the view
# ・data increase or decrease correctly.

# Since it is the responsibility of the controller's internal implementation to ensure 
# that the correct object is stored in the response template, we won't test it here

RSpec.describe "DevisePasswordUpdateController", type: :request do

  # ===================== #
  # examples_for response #
  # ===================== #
  shared_examples_for "return http" do |code|
    it { subject; expect(response).to have_http_status(code)}
  end

  shared_examples_for "include error message" do |msg|
    it { subject; expect(response.body).to include msg }
  end
  
  shared_examples_for "redirect to user_path" do
    it { subject; expect(response).to redirect_to user_path(registered_user.user_id) }
  end

  shared_examples_for "redirect to login_path" do
    it { subject; expect(response).to redirect_to new_user_session_path }
  end

  # ================== #
  # examples_for model #
  # ================== #

  # It's the model's responsibility to make sure the values are changed correctly, so we won't test it here.
  shared_examples_for "update Model" do |model|
    it { expect{subject}.to change{model.count}.by(0) }
  end





  # ============= #
  # edit action #
  # ============= #
  describe 'GET users/password_update#edit' do
    subject { get edit_users_password_path }
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
    subject { put users_password_path, params: { user_password: params }}
    let(:registered_user) { create(:valid_user) }

    context 'case of Logged in' do
      before { sign_in registered_user }

      context 'with valid params' do
        let(:params) do 
          { 
            password: "newpassword",
            password_confirmation: "newpassword",
            current_password: registered_user.password
          }
        end

        it_behaves_like "return http", 302
        it_behaves_like "redirect to user_path", 302
        it 'updates user' do
          subject
          registered_user.reload
          expect(registered_user.valid_password?(params[:password])).to eq(true)
        end
      end


      context 'with invalid params : short password case' do
        let(:params) do 
          { 
            password: "mini",
            password_confirmation: "mini",
            current_password: registered_user.password
          }
        end
        
        it_behaves_like "return http", 200
        it_behaves_like "include error message", 'パスワード は8文字以上で入力してください'
        it 'failure to updates user' do
          subject
          registered_user.reload
          expect(registered_user.valid_password?(params[:password])).to eq(false)
        end
      end
      

      context 'with invalid params : invalid current_password case' do
        let(:params) do 
          { 
            password: "newpassword",
            password_confirmation: "newpassword",
            current_password: "invalid_password"
          }
        end
        
        it_behaves_like "return http", 200
        it_behaves_like "include error message", '現在のパスワード が間違っています'
        it 'failure to updates user' do
          subject
          registered_user.reload
          expect(registered_user.valid_password?(params[:password])).to eq(false)
        end
      end

    end


    context 'case of being not Logged in' do
      let(:params) do 
        {
          password: "new_password",
          password_confirmation: "new_password",
          current_password: registered_user.password
        }
      end

      it_behaves_like "return http", 302
      it_behaves_like "redirect to login_path"
    end

  end


end