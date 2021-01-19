require 'rails_helper'
RSpec.describe "ApexProfile", type: :request do

  # ===================== #
  # examples_for response #
  # ===================== #
  shared_examples_for "return http" do |code|
    it { subject; expect(response).to have_http_status(code)}
  end

  shared_examples_for "include error message" do |msg|
    it { subject; expect(response.body).to include msg }
  end

  shared_examples_for "redirect to login_path" do
    it { subject; expect(response).to redirect_to new_user_session_path }
  end

  shared_examples_for "redirect to registered_user_path" do
    it { subject; expect(response).to redirect_to user_path(registered_user.user_id) }
  end

  shared_examples_for "redirect to new_apex_profile_path" do
    it { subject; expect(response).to redirect_to new_apex_profile_path }
  end

  shared_examples_for "redirect to edit_apex_profile_path" do
    it { subject; expect(response).to redirect_to edit_apex_profile_path }
  end




  # ================== #
  # examples_for model #
  # ================== #
  shared_examples_for "create Model" do |model, count|
    it { expect{subject}.to change(model, :count).by(count) }
  end

  shared_examples_for "Failing to create Model" do |model|
    it { expect{subject}.to_not change(model, :count) }
  end

  # It's the model's responsibility to make sure the values are changed correctly, so we won't test it here.
  shared_examples_for "update Model" do |model|
    it { expect{subject}.to change{model.count}.by(0) }
  end


  # create test data of Legend model and Weapon model 
  before {
    create(:wraith)
    create(:wattson)
    create(:flatline)
    create(:g7)
  }


  # ============= #
  # new action #
  # ============= #
  describe 'GET apex_profile#new' do
    subject { get new_apex_profile_path }
    let(:registered_user) { create(:valid_user) }

    context 'case of Logged in' do
      before { sign_in registered_user }

      it_behaves_like "return http", 200
    end

    context 'case that user have already created a apex_profile' do
      before { 
        registered_user.create_apex_profile(attributes_for(:valid_apex_profile))
        sign_in registered_user
      }

      it_behaves_like "return http", 302
      it_behaves_like "redirect to edit_apex_profile_path"
    end

    context 'case of being not Logged in' do
      it_behaves_like "return http", 302
      it_behaves_like "redirect to login_path"
    end

  end


  # ============= #
  # create action #
  # ============= #
  describe 'POST apex_profile#create' do
    subject { post apex_profile_path, params: { apex_profile: params }}
    let(:registered_user) { create(:valid_user) }

    context 'case of Logged in' do
      before { sign_in registered_user }

      context 'with valid params' do
        let(:params) { attributes_for(:valid_apex_profile, weapon_ids: [0,1], legend_ids: [0,1]) }

        it_behaves_like "return http", 302
        it_behaves_like "create Model", ApexProfile, 1
        it_behaves_like "create Model", FavoriteLegend, 2
        it_behaves_like "create Model", FavoriteWeapon, 2
        it "redirect user_path"do 
          subject
          expect(response).to redirect_to user_path(registered_user.user_id)
        end
      end

      context 'with invalid params : long apex_id case' do
        let(:params) { attributes_for(:valid_apex_profile, apex_id: "a"*33) }
        
        it_behaves_like "return http", 200
        it_behaves_like "Failing to create Model", ApexProfile
        it_behaves_like "include error message", 'APEX_ID は32文字以下にしてください'
      end
    end

    context 'case of being not Logged in' do
      let(:params) { attributes_for(:valid_apex_profile) }

      it_behaves_like "return http", 302
      it_behaves_like "redirect to login_path"
    end

  end



  # ============= #
  # edit action #
  # ============= #
  describe 'GET apex_profile#edit' do
    subject { get edit_apex_profile_path }
    let(:registered_user) { create(:valid_user) }

    context 'case of Logged in' do
      before { sign_in registered_user }

      context 'case that user have already created apex_profile' do
        before {
          registered_user.create_apex_profile(attributes_for(:valid_apex_profile))
        }
        it_behaves_like "return http", 200
      end

      context 'case that user do not have apex_profile' do
        it_behaves_like "return http", 302
        it_behaves_like "redirect to new_apex_profile_path"
      end

    end

    context 'case of being not Logged in' do
      it_behaves_like "return http", 302
      it_behaves_like "redirect to login_path"
    end

  end



  # ============= #
  # update action #
  # ============= #
  describe 'PUT apex_profile#update' do
    subject { put apex_profile_path, params: { apex_profile: params }}
    let(:registered_user) { create(:valid_user) }

    context 'case of Logged in' do
      before { sign_in registered_user }

      context 'with valid params' do
        before {
          registered_user.create_apex_profile(attributes_for(:valid_apex_profile))
        }

        let(:params) { attributes_for(:valid_apex_profile, apex_id: "update_valid_apex_id") }

        it_behaves_like "return http", 302
        it_behaves_like "redirect to registered_user_path"
        it 'updates apex_profile' do
          subject
          registered_user.reload
          expect(registered_user.apex_profile.apex_id).to eq params[:apex_id]
        end

        context 'with invalid params : long apex_id case' do
          let(:params) { attributes_for(:valid_apex_profile, apex_id: "a"*33) }
          
          it_behaves_like "return http", 200
          it_behaves_like "include error message", 'APEX_ID は32文字以下にしてください'
        end
      end

      context 'case that user do not have apex_profile' do
        let(:params) { attributes_for(:valid_apex_profile, apex_id: "update_valid_apex_id") }

        it_behaves_like "return http", 302
        it_behaves_like "redirect to new_apex_profile_path"
      end

    end


    context 'case of being not Logged in' do
      let(:params) { attributes_for(:valid_apex_profile, apex_id: "update_valid_apex_id") }

      it_behaves_like "return http", 302
      it_behaves_like "redirect to login_path"
    end

  end


  # ============= #
  # destroy action #
  # ============= #
  describe 'DELETE apex_profile#destroy' do
    subject { delete apex_profile_path }
    let(:registered_user) { create(:valid_user) }

    context 'case of Logged in' do
      before {
        registered_user.create_apex_profile(attributes_for(:valid_apex_profile))
        sign_in registered_user
      }

      it "delete apex_profile" do
         expect{subject}.to change(ApexProfile, :count).by(-1) 
      end
    end

    context 'case of being not Logged in' do
      it_behaves_like "return http", 302
      it_behaves_like "redirect to login_path"
    end

  end

end
