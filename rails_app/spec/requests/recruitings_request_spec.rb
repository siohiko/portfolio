require 'rails_helper'
RSpec.describe "Recruitings", type: :request do

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

  shared_examples_for "redirect to recruiting_path" do
    it { subject; expect(response).to redirect_to recruiting_path(registered_user.recruiting) }
  end

  shared_examples_for "redirect to new_recruiting_path" do
    it { subject; expect(response).to redirect_to new_recruiting_path }
  end

  shared_examples_for "redirect to edit_recruiting_path" do
    it { subject; expect(response).to redirect_to edit_recruiting_path(registered_user.recruiting.id) }
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

  shared_examples_for "update Model" do |model|
    it { expect{subject}.to change{model.count}.by(0) }
  end


  # ============= #
  # new action #
  # ============= #
  describe 'GET recruiting#new' do
    subject { get new_recruiting_path }
    let(:registered_user) { create(:valid_user) }

    context 'case of Logged in' do
      before { sign_in registered_user }

      it_behaves_like "return http", 200
    end

    context 'case that user have already created a recruiting' do
      before { 
        registered_user.create_recruiting(attributes_for(:valid_recruiting))
        sign_in registered_user
      }

      it_behaves_like "return http", 302
      it_behaves_like "redirect to edit_recruiting_path"
    end

    context 'case of being not Logged in' do
      it_behaves_like "return http", 302
      it_behaves_like "redirect to login_path"
    end

  end


  # ============= #
  # create action #
  # ============= #
  describe 'POST recruiting#create' do
    subject { post recruitings_path, params: { recruiting: params }}
    let(:registered_user) { create(:valid_user) }

    context 'case of Logged in' do
      before { sign_in registered_user }

      context 'with valid params' do
        let(:params) { attributes_for(:valid_recruiting) }

        it_behaves_like "return http", 302
        it_behaves_like "create Model", Recruiting, 1
        it "redirect recruiting_path"do 
          subject
          expect(response).to redirect_to recruiting_path(registered_user.recruiting.id)
        end
      end

      context 'with invalid value of type' do
        let(:params) { attributes_for(:valid_recruiting, type: "no_game") }

        it_behaves_like "return http", 200
        it_behaves_like "Failing to create Model", Recruiting
        it_behaves_like "include error message", '指定のゲームは募集できません'
      end

      context 'without type' do
        let(:params) { attributes_for(:valid_recruiting, type: nil) }

        it_behaves_like "return http", 200
        it_behaves_like "Failing to create Model", Recruiting
        it_behaves_like "include error message", '指定のゲームは募集できません'
      end

      context 'without recruitment_numbers' do
        let(:params) { attributes_for(:valid_recruiting, recruitment_numbers: nil) }

        it_behaves_like "return http", 200
        it_behaves_like "Failing to create Model", Recruiting
        it_behaves_like "include error message", '募集人数 を入力してください'
      end

      context 'with invalid params : long play_style case' do
        let(:params) { attributes_for(:valid_recruiting, play_style: "a"*33) }

        it_behaves_like "return http", 200
        it_behaves_like "Failing to create Model", Recruiting
        it_behaves_like "include error message", 'プレイスタイル は32文字以下にしてください'
      end

      context 'with invalid params : long play_style case' do
        let(:params) { attributes_for(:valid_recruiting, comment: "a"*256) }

        it_behaves_like "return http", 200
        it_behaves_like "Failing to create Model", Recruiting
        it_behaves_like "include error message", 'コメント は255文字以下にしてください'
      end
      
    end

    context 'case of being not Logged in' do
      let(:params) { attributes_for(:valid_recruiting) }

      it_behaves_like "return http", 302
      it_behaves_like "redirect to login_path"
    end

  end



  # ============= #
  # edit action #
  # ============= #
  describe 'GET recruiting#edit' do
    let(:registered_user) { create(:valid_user) }

    context 'case of Logged in' do
      before { sign_in registered_user }

      context 'case that user have already created recruiting' do
        subject { get edit_recruiting_path(registered_recruiting.id) }
        let(:registered_recruiting) { registered_user.create_recruiting(attributes_for(:valid_recruiting)) }
        before { registered_recruiting }

        it_behaves_like "return http", 200
      end

      context 'case that user do not have recruiting' do
        subject { get edit_recruiting_path(1) }

        it_behaves_like "return http", 302
        it_behaves_like "redirect to new_recruiting_path"
      end

    end

    context 'case of being not Logged in' do
      subject { get edit_recruiting_path(1) }

      it_behaves_like "return http", 302
      it_behaves_like "redirect to login_path"
    end

  end



  # ============= #
  # update action #
  # ============= #
  describe 'PUT recruiting#update' do
    let(:registered_user) { create(:valid_user) }

    context 'case of Logged in' do
      before { sign_in registered_user }

      context 'with valid params' do
        subject { put recruiting_path(registered_recruiting), params: { recruiting: params }}
        let(:registered_recruiting) { registered_user.create_recruiting(attributes_for(:valid_recruiting)) }
        before { registered_recruiting }

        let(:params) { attributes_for(:valid_recruiting, comment: "update") }

        it_behaves_like "return http", 302

        it "redirect recruiting_path"do 
          subject
          expect(response).to redirect_to recruiting_path(registered_recruiting)
        end

        it 'updates recruiting' do
          subject
          registered_recruiting.reload
          expect(registered_recruiting.comment).to eq params[:comment]
        end
      end


      context 'case that user do not have recruiting' do
        subject { put recruiting_path(1), params: { recruiting: params }}
        let(:params) { attributes_for(:valid_recruiting, comment: "update") }

        it_behaves_like "return http", 302
        it_behaves_like "redirect to new_recruiting_path"
      end


      context 'case of invalid params' do
        subject { put recruiting_path(registered_recruiting), params: { recruiting: params }}
        let(:registered_recruiting) { registered_user.create_recruiting(attributes_for(:valid_recruiting)) }
        before { registered_recruiting }

        context 'with invalid type' do
          let(:params) { attributes_for(:valid_recruiting, type: "no_game") }
  
          it_behaves_like "return http", 200
          it_behaves_like "include error message", '指定のゲームは募集できません'
        end

        context 'without type' do
          let(:params) { attributes_for(:valid_recruiting, type: nil) }
  
          it_behaves_like "return http", 200
          it_behaves_like "include error message", '指定のゲームは募集できません'
        end
  
        context 'without recruitment_numbers' do
          let(:params) { attributes_for(:valid_recruiting, recruitment_numbers: nil) }
  
          it_behaves_like "return http", 200
          it_behaves_like "include error message", '募集人数 を入力してください'
        end

        context 'with invalid params : long play_style case' do
          let(:params) { attributes_for(:valid_recruiting, play_style: "a"*33) }
  
          it_behaves_like "return http", 200
          it_behaves_like "include error message", 'プレイスタイル は32文字以下にしてください'
        end
  
        context 'with invalid params : long play_style case' do
          let(:params) { attributes_for(:valid_recruiting, comment: "a"*256) }
  
          it_behaves_like "return http", 200
          it_behaves_like "include error message", 'コメント は255文字以下にしてください'
        end
      end
      
    end



    context 'case of being not Logged in' do
      subject { put recruiting_path(1), params: { recruiting: params }}
      let(:params) { attributes_for(:valid_recruiting, comment: "update") }

      it_behaves_like "return http", 302
      it_behaves_like "redirect to login_path"
    end

  end


  # ============== #
  # destroy action #
  # ============== #
  describe 'DELETE recruiting#destroy' do
    subject { delete recruiting_path(registered_recruiting) }
    let(:registered_recruiting) { registered_user.create_recruiting(attributes_for(:valid_recruiting)) }
    let(:registered_user) { create(:valid_user) }

    context 'case of Logged in' do
      before {
        registered_recruiting
        sign_in registered_user
      }

      it "delete apex_profile" do
         expect{subject}.to change(Recruiting, :count).by(-1) 
      end
    end

    context 'case of being not Logged in' do
      it_behaves_like "return http", 302
      it_behaves_like "redirect to login_path"
    end

  end



  # ============== #
  # show action #
  # ============== #
  describe 'GET recruiting#show' do
    subject { get recruiting_path(registered_recruiting) }
    let(:registered_recruiting) { registered_user.create_recruiting(attributes_for(:valid_recruiting)) }
    let(:registered_user) { create(:valid_user) }

    context 'case of Logged in' do
      before {
        registered_recruiting
        sign_in registered_user
      }

      it_behaves_like "return http", 200
    end

    context 'case of being not Logged in' do
      it_behaves_like "return http", 302
      it_behaves_like "redirect to login_path"
    end

  end

end
