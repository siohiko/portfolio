require 'rails_helper'

RSpec.describe "Comments", type: :request do

  # ===================== #
  # examples_for response #
  # ===================== #
  shared_examples_for "return http" do |code|
    it { subject; expect(response).to have_http_status(code)}
  end

  shared_examples_for "redirect to login_path" do
    it { subject; expect(response).to redirect_to new_user_session_path }
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



  # ============== #
  # create action   #
  # ============== #
  describe 'POST comments#create' do

    context 'case of Logged in' do
      subject { post comments_path , params: { comment: params }}
      before { sign_in registered_user}
      let(:registered_user) { create(:valid_user) }

      context 'when user is owner of recruiting' do
        let(:recruiting) { registered_user.create_recruiting(attributes_for(:recruiting_mock))}
        let(:params) { { content: 'コメント', recruiting_id: recruiting.id } }

        it_behaves_like "return http", 201
        it_behaves_like "create Model", Comment, 1
      end


      context 'when user is member' do
        let(:recruiting) { create(:valid_recruitings) }
        let(:params) { { content: 'コメント', recruiting_id: recruiting.id } }
        before{
          recruiting.applicants << registered_user
          recruiting.reload.applicant_entry_recruitings[0].approved!
        }

        it_behaves_like "return http", 201
        it_behaves_like "create Model", Comment, 1
      end


      context 'when user is applicant' do
        let(:recruiting) { create(:valid_recruitings) }
        let(:params) { { content: 'コメント', recruiting_id: recruiting.id } }
        before{
          recruiting.applicants << registered_user
        }

        it_behaves_like "return http", 409
        it_behaves_like "Failing to create Model", Comment, 1
      end


      context 'when user is generala user' do
        let(:recruiting) { create(:valid_recruitings) }
        let(:params) { { content: 'コメント', recruiting_id: recruiting.id } }

        it_behaves_like "return http", 409
        it_behaves_like "Failing to create Model", Comment, 1
      end


    end


    context 'case of being not Logged in' do
      subject { post comments_path , params: { comment: params }}
      let(:recruiting) { create(:valid_recruitings) }
      let(:params) { { content: 'コメント', recruiting_id: recruiting.id } }

      it_behaves_like "return http", 302
      it_behaves_like "redirect to login_path"
    end

  end
end
