require 'rails_helper'
RSpec.describe "ApplicantEntryRecruitings", type: :request do

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



  # ================== #
  # examples_for model #
  # ================== #
  shared_examples_for "create Model" do |model, count|
    it { expect{subject}.to change(model, :count).by(count) }
  end

  shared_examples_for "update Model" do |model|
    it { expect{subject}.to change{model.count}.by(0) }
  end

  shared_examples_for "Failing to create Model" do |model|
    it { expect{subject}.to_not change(model, :count) }
  end


  # ============= #
  # index action #
  # ============= #
  describe 'GET applicant_entry_recruitings#index' do
    subject { get applicant_entry_recruitings_path, params: { applicant_entry_recruiting: params }}
    let(:recruiting) { create(:valid_recruiting, :recruiting_with_applicant) }
    let(:owner) { recruiting.user }

    context 'case of Logged in' do
      context 'if user is owner' do
        let(:params) { {recruiting_id: recruiting.id} }
        before { sign_in owner }

        it_behaves_like "return http", 200
        it 'return valid allicants data' do
          subject
          json = JSON.parse(response.body)
          expect(json['applicants'].length).to eq(2)
        end
      end

      context 'if user is another user' do
        let(:params) { {recruiting_id: recruiting.id} }
        let(:another_user) { create(:valid_users) }
        before { sign_in another_user }

        it_behaves_like "return http", 401
      end
    end

    context 'case of being not Logged in' do
      let(:params) { {recruiting_id: recruiting.id} }
      it_behaves_like "return http", 302
      it_behaves_like "redirect to login_path"
    end
  end

  # ============= #
  # create action #
  # ============= #
  describe 'POST applicant_entry_recruitings#create' do
    subject { post applicant_entry_recruitings_path, params: { applicant_entry_recruiting: params }}
    let(:recruiter) { create(:recruiter, :user_with_recruiting) }
    let(:applicant) { create(:valid_users) }
    let(:params) { {recruiting_id: recruiter.recruiting.id} }

    context 'case of Logged in' do
      before { sign_in applicant }

      context 'case of correct application' do
        it_behaves_like "return http", 201
        it_behaves_like "create Model", ApplicantEntryRecruiting, 1
      end

      context 'if recruiting is closed' do
        before { recruiter.recruiting.update(status: "close") }

        it_behaves_like "return http", 409
        it_behaves_like "Failing to create Model", ApplicantEntryRecruiting
        it_behaves_like "include error message", 'その募集には応募できません'
      end

    end


    context 'if applicant is owner of recruiting' do
      before { sign_in recruiter }

      it_behaves_like "return http", 409
      it_behaves_like "Failing to create Model", ApplicantEntryRecruiting
      it_behaves_like "include error message", 'あなた自身がかけた募集には応募できません'
    end

    context 'case of being not Logged in' do
      it_behaves_like "return http", 302
      it_behaves_like "redirect to login_path"
    end
  end

  
  # ============= #
  # update action #
  # ============= #
  describe 'PUT applicant_entry_recruitings#update' do
    subject { put applicant_entry_recruitings_path, params: { applicant_entry_recruiting: params }}
    let(:recruiter) { create(:recruiter, :user_with_recruiting) }
    let(:applicant) { create(:valid_users) }
    let(:params) { 
      { 
        applicant_id: applicant.user_id, 
        recruiting_id: recruiter.recruiting.id,
        status: "approved"
      }
    }

    context 'case that owner logged in' do
      before { 
        recruiter.recruiting.applicants << applicant
        sign_in recruiter 
      }

      context 'case of correct application' do
        it_behaves_like "return http", 201
        it 'updates applicant_entry_recruitings' do
          subject
          expect(recruiter.recruiting.applicant_entry_recruitings[0].status).to eq params[:status]
        end
      end

    end

    context 'case that another_user logged in' do
      let(:another_user) { create(:valid_users) }
      before { sign_in another_user }

      it_behaves_like "return http", 401
    end

    context 'case of being not Logged in' do
      it_behaves_like "return http", 302
      it_behaves_like "redirect to login_path"
    end

  end



  # ============== #
  # destroy action #
  # ============== #
  describe 'DELETE applicant_entry_recruitings#destroy' do
    subject { delete applicant_entry_recruitings_path, params: { applicant_entry_recruiting: params } } 
    let(:recruiting) { create(:valid_recruiting, :recruiting_with_applicant) }
    let(:decliner) { recruiting.applicants[0] }
    let(:params) { 
      { 
        recruiting_id: recruiting.id,
        delete_reason: 'refusal'
      }
    }

    context 'case of decliner Logged in' do
      before {
        recruiting 
        sign_in decliner 
      }

      it "delete entry" do
        expect{subject}.to change(ApplicantEntryRecruiting, :count).by(-1)
      end

      it 'the decliners are declining properly' do
        subject
        expect(recruiting.reload.applicants.include?(decliner)).to eq false
      end

      it_behaves_like "create Model", DeleteEntryNotice, 1
    end

    context 'case of another_user Logged in' do
      let(:another_user) { create(:valid_users) }
      before { 
        recruiting
        sign_in another_user 
      }

      it "do not delete entry" do
        expect{subject}.to change(ApplicantEntryRecruiting, :count).by(0)
      end

      it 'users are not being turned down on their own' do
        subject
        expect(recruiting.reload.applicants.include?(decliner)).to eq true
      end
    end

    context 'case of being not Logged in' do
      it_behaves_like "return http", 302
      it_behaves_like "redirect to login_path"
    end

  end
end
