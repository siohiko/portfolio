require 'rails_helper'

# Items to be verified
# ・return the correct http status code
# ・being redirected to the correct page.
# ・contains a message that should be displayed in the view
# ・data increase or decrease correctly.

# Since it is the responsibility of the controller's internal implementation to ensure 
# that the correct object is stored in the response template, we won't test it here

RSpec.describe "DeviseUsersSessionsController", type: :request do

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






  # ============= #
  # new action #
  # ============= #
  describe 'GET devise/sessions#new' do
    subject { get new_user_session_path }

    context 'case of Logged in' do
      let(:registered_user) { create(:valid_user) }
      before { sign_in registered_user}
      
      it "redirect to registered_user_path" do
        subject
        expect(response).to redirect_to user_path(registered_user.user_id)
      end

    end
    

    context 'case of being not Logged in' do
      it_behaves_like "return http", 200
    end
    
  end



  # ============= #
  # create action #
  # ============= #
  describe 'POST devise/registrations#create' do
    subject { post user_session_path, params: { user: params }}

    context 'with valid params' do
      let(:registered_user) { create(:valid_user) }
      let(:params) { attributes_for(:valid_user) }
      before { registered_user }

      it_behaves_like "return http", 302
      
      it 'redirect to user_path' do
        subject
        expect(response).to redirect_to user_path(registered_user.user_id)
      end

      it 'have session' do
        subject
        expect(session.keys.include?('warden.user.user.key')).to be true
      end

    end

    context 'with invalid params' do
      let(:registered_user) { create(:valid_user) }
      let(:params) { attributes_for(:valid_user, password: "") }
      before { registered_user }

      it_behaves_like "return http", 200
      
      it 'include error message' do
        subject
        expect(response.body).to include 'IDまたはパスワードが違います'
      end

    end
  end


  # ============= #
  # delete action #
  # ============= #
  describe 'DELETE devise/registrations#destroy' do
    subject { get destroy_user_session_path }

    let(:registered_user) { create(:valid_user) }
    before { sign_in registered_user;}

    it 'have no session' do
      subject
      expect(session.keys.include?('warden.user.user.key')).to be false
    end
  end

end