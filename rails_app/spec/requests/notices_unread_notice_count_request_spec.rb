require 'rails_helper'

RSpec.describe "Notices::UnreadNoticeCountsController", type: :request do

  # ===================== #
  # examples_for response #
  # ===================== #
  shared_examples_for "return http" do |code|
    it { subject;expect(response).to have_http_status(code)}
  end

  # ============== #
  #  show action   #
  # ============== #
  describe 'GET notices#show' do

    context 'case of Logged in' do
      subject { get notices_unread_notice_count_path }
      let(:registered_user) { create(:valid_user) }
      
      before { 
        3.times do
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
      it "return unread notice count" do
        subject
        expect(JSON.parse(response.body)['unread_count']).to eq(3)
      end
    end


    context 'case of being not Logged in' do
      subject { get notices_unread_notice_count_path }

      it_behaves_like "return http", 401
    end

  end
end
