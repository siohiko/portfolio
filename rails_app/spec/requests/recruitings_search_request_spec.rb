require 'rails_helper'

# Items to be verified
# ・return the correct http status code
# ・being redirected to the correct page.
# ・contains a message that should be displayed in the view
# ・data increase or decrease correctly.

# Since it is the responsibility of the controller's internal implementation to ensure 
# that the correct object is stored in the response template, we won't test it here

RSpec.describe "Recruitings::Search", type: :request do

  # ===================== #
  # examples_for response #
  # ===================== #
  shared_examples_for "return http" do |code|
    it { subject; expect(response).to have_http_status(code)}
  end

  shared_examples_for "include recruitings information" do |text|
    it { subject; expect(response.body).to include text }
  end

  shared_examples_for "redirect to login_path" do
    it { subject; expect(response).to redirect_to new_user_session_path }
  end



  # ============== #
  # show action #
  # ============== #
  describe 'GET recruitings::search#show' do

    context 'case of Logged in' do
      subject { get recruitings_search_path, params: { search: params } }
      let(:registered_user) { create(:valid_user) }
      
      before { 
        rank_arr = [ 
          'ブロンズ',
          'ブロンズ',
          'ブロンズ',
          'シルバー',
          'シルバー',
          'シルバー',
          'シルバー',
          'ゴールド',
          'プラチナ',
          'ダイヤ',
          'マスター',
        ]
        rank_arr.each do |rank| 
          create(:recruiters, rank: rank)  
        end
        sign_in registered_user
      }

      context 'Search terms are rank = ブロンズ' do
        let(:params) { { type: "ApexRecruiting", rank: "ブロンズ" }  }

        it_behaves_like "return http", 200
        it_behaves_like "include recruitings information", '3件'
      end

      context 'Search terms are rank = プレデター' do
        let(:params) { { type: "ApexRecruiting", rank: "プレデター" }  }

        it_behaves_like "return http", 200
        it_behaves_like "include recruitings information", '0件'
      end
    end


    context 'case of being not Logged in' do
      subject { get recruitings_search_path }

      it_behaves_like "return http", 302
      it_behaves_like "redirect to login_path"
    end

  end
end
