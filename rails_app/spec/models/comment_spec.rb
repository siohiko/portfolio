# == Schema Information
#
# Table name: comments
#
#  id            :bigint           not null, primary key
#  content       :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  recruiting_id :integer
#  user_id       :string
#
# Indexes
#
#  index_comments_on_recruiting_id  (recruiting_id)
#  index_comments_on_user_id        (user_id)
#
require 'rails_helper'

RSpec.describe Comment, type: :model do
  # ===================== #
  #      examples_for     #
  # ===================== #
  subject(:model_valid) { verified_comment.valid? }

  shared_examples_for "is valid" do
    it { model_valid; expect(verified_comment).to be_valid}
  end

  shared_examples_for "is invalid" do
    it { model_valid; expect(verified_comment).to be_invalid}
  end

  shared_examples_for "include error message" do |msg, symbol|
    it { model_valid; expect(verified_comment.errors[symbol]).to include msg }
  end

  # ============= #
  #    validate   #
  # ============= #
  describe 'about validate' do
    let(:recruiting) { create(:valid_recruitings) }
    let(:owner) { recruiting.user }
    let(:member) { create(:valid_users) }
    let(:applicant) { create(:valid_users) }
    let(:general_user) { create(:valid_users) }
    before {
      recruiting.applicants << member
      recruiting.reload.applicant_entry_recruitings[0].approved!
      recruiting.applicants << applicant
    }

    context 'make owner of recruiting comment' do
      let(:verified_comment) { build(:comment_mock, user_id: owner.user_id, recruiting_id: recruiting.id) }
      it_behaves_like "is valid"
    end

    context 'make member of recruiting comment' do
      let(:verified_comment) { build(:comment_mock, user_id: member.user_id, recruiting_id: recruiting.id) }
      it_behaves_like "is valid"
    end

    context 'make applicant of recruiting comment' do
      let(:verified_comment) { build(:comment_mock, user_id: applicant.user_id, recruiting_id: recruiting.id) }
      it_behaves_like "is invalid"
      it_behaves_like "include error message", 'コメント投稿の権限がありません', :authority
    end

    context 'make general user comment' do
      let(:verified_comment) { build(:comment_mock, user_id: general_user.user_id, recruiting_id: recruiting.id) }
      it_behaves_like "is invalid"
      it_behaves_like "include error message", 'コメント投稿の権限がありません', :authority
    end

    context 'without recruiting_id' do
      let(:verified_comment) { build(:comment_mock, user_id: owner.user_id) }
      it_behaves_like "is invalid"
    end

    context 'without recruiting_id' do
      let(:verified_comment) { build(:comment_mock, recruiting_id: recruiting.id) }
      it_behaves_like "is invalid"
    end
  end



  # ============= #
  #    relation   #
  # ============= #
  describe 'about relation' do
    let(:recruiting) { create(:valid_recruitings) }
    let(:owner) { recruiting.user }

    context 'when delete user' do
      let(:comment) { create(:comment_mock, user_id: owner.user_id, recruiting_id: recruiting.id) }
      before { comment }

      it 'delete notice too' do 
        count = Comment.all.count
        comment.user.destroy
        expect(Comment.all.count).to eq (count - 1)
      end
    end


    context 'when delete recruiting' do
      let(:comment) { create(:comment_mock, user_id: owner.user_id, recruiting_id: recruiting.id) }
      before { comment }

      it 'delete notice too' do 
        count = Comment.all.count
        comment.recruiting.destroy
        expect(Comment.all.count).to eq (count - 1)
      end
    end

  end

end

