require 'rails_helper'

# Items to be verified
# ・return the correct http status code
# ・being redirected to the correct page.
# ・contains a message that should be displayed in the view
# ・data increase or decrease correctly.

# Since it is the responsibility of the controller's internal implementation to ensure 
# that the correct object is stored in the response template, we won't test it here

RSpec.describe "Users", type: :request do

  # ===================== #
  # examples_for response #
  # ===================== #
  shared_examples_for "return http" do |code|
    it { subject; expect(response).to have_http_status(code)}
  end

  shared_examples_for "redirect to login_path" do
    it { subject; expect(response).to redirect_to new_user_session_path }
  end

  describe "GET /show" do
    subject { get user_path(registered_user.user_id) }

    context 'case of Logged in' do
      let(:registered_user) { create(:valid_user) }
      before { sign_in registered_user }
      it_behaves_like "return http", 200
    end
    
    context 'case of being not Logged in' do
      let(:registered_user) { create(:valid_user) }
      it_behaves_like "return http", 302
      it_behaves_like "redirect to login_path"
    end

  end
end
