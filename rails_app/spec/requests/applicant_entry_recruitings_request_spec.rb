require 'rails_helper'

# Items to be verified
# ・return the correct http status code
# ・being redirected to the correct page.
# ・contains a message that should be displayed in the view
# ・data increase or decrease correctly.

# Since it is the responsibility of the controller's internal implementation to ensure 
# that the correct object is stored in the response template, we won't test it here

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

  # It's the model's responsibility to make sure the values are changed correctly, so we won't test it here.
  shared_examples_for "update Model" do |model|
    it { expect{subject}.to change{model.count}.by(0) }
  end

  shared_examples_for "Failing to create Model" do |model|
    it { expect{subject}.to_not change(model, :count) }
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
        it_behaves_like "include error message", 'その募集は既に閉じられています'
      end

      context 'if recruitment_numbers is 0' do
        before { recruiter.recruiting.update(recruitment_numbers: 0) }

        it_behaves_like "return http", 409
        it_behaves_like "Failing to create Model", ApplicantEntryRecruiting
        it_behaves_like "include error message", 'その募集は既に満員です'
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

      context 'case that recruiting is closed' do
        before { recruiter.recruiting.close! }

        it_behaves_like "return http", 409
        it_behaves_like "include error message", 'その募集は既に閉じられています'
        it 'do not updates applicant_entry_recruitings' do
          subject
          expect(recruiter.recruiting.applicant_entry_recruitings[0].status).to_not eq params[:status]
        end
      end

      context 'case that recruiting is filled' do
        before { recruiter.recruiting.update(recruitment_numbers: 0) }

        it_behaves_like "return http", 409
        it_behaves_like "include error message", 'その募集は既に満員です'
        it 'do not updates applicant_entry_recruitings' do
          subject
          expect(recruiter.recruiting.applicant_entry_recruitings[0].status).to_not eq params[:status]
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

end
