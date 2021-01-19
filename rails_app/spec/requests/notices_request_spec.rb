require 'rails_helper'

RSpec.describe "Notices", type: :request do

  # ===================== #
  # examples_for response #
  # ===================== #
  shared_examples_for "return http" do |code|
    it { subject; expect(response).to have_http_status(code)}
  end

  shared_examples_for "include notices information" do |text|
    it { subject; expect(response.body).to include text }
  end

  shared_examples_for "redirect to login_path" do
    it { subject; expect(response).to redirect_to new_user_session_path }
  end



  # ============== #
  # index action   #
  # ============== #
  describe 'GET notices#index' do

    context 'case of Logged in' do
      subject { get notices_path }
      let(:registered_user) { create(:valid_user) }
      
      before { 
        5.times do
          registered_user.notices.create(
            type: 'DeleteEntryNotice',
            title: '参加申請が拒否されました',
            content: '内容',
            status: 'unread',
            reason_for_delete_entry: 'refusal',

            #通知クラスの募集IDと応募者IDは各々のクラスに依存してないので適当にいれる
            recruiting_id: 1,
            applicant_id: 'test'
          )
        end
        sign_in registered_user
      }

      it_behaves_like "return http", 200
      it_behaves_like "include notices information", '未読5件'

      it 'update status to read after index action' do
        subject
        notices = Notice.where(status: 'unread')
        expect(notices.size).to eq 0
      end

    end


    context 'case of being not Logged in' do
      subject { get notices_path }

      it_behaves_like "return http", 302
      it_behaves_like "redirect to login_path"
    end

  end
end
