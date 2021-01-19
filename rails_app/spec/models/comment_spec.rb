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

    context 'make general user comment' do
      let(:verified_comment) { build(:general_user_comment) }
      it_behaves_like "is valid"
    end

  end



  # ============= #
  #    relation   #
  # ============= #
  describe 'about relation' do

    context 'when delete user' do
      let(:comment) { create(:general_user_comment) }
      before { comment }

      it 'delete notice too' do 
        count = Comment.all.count
        comment.user.destroy
        expect(Comment.all.count).to eq (count - 1)
      end
    end


    context 'when delete recruiting' do
      let(:comment) { create(:general_user_comment) }
      before { comment }

      it 'delete notice too' do 
        count = Comment.all.count
        comment.recruiting.destroy
        expect(Comment.all.count).to eq (count - 1)
      end
    end

  end

end

