# == Schema Information
#
# Table name: recruitings
#
#  id                   :bigint           not null, primary key
#  comment              :text
#  game_mode            :integer
#  participants_numbers :integer          default(0)
#  play_style           :text
#  rank                 :integer
#  recruitment_numbers  :integer
#  status               :integer          default("open"), not null
#  type                 :string           not null
#  vc                   :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  user_id              :string(32)       not null
#
require 'rails_helper'

RSpec.describe Recruiting, type: :model do
  # ===================== #
  #      examples_for     #
  # ===================== #
  subject(:model_valid) { verified_recruiting.valid? }

  shared_examples_for "is valid" do
    it { model_valid; expect(verified_recruiting).to be_valid}
  end

  shared_examples_for "is invalid" do
    it { model_valid; expect(verified_recruiting).to be_invalid}
  end

  shared_examples_for "include error message" do |msg, symbol|
    it { model_valid; expect(verified_recruiting.errors[symbol]).to include msg }
  end

  # ============= #
  #    validate   #
  # ============= #
  # notice: no test for enum.

  describe 'about validate' do

    context 'with valid params ' do
      let(:verified_recruiting) { build(:valid_recruiting) }
      it_behaves_like "is valid"
    end

    context 'already been created' do
      let(:created_valid_recruiting) { create(:valid_recruiting) }
      let(:verified_recruiting) { build(:valid_recruiting) }
      before { 
        created_valid_recruiting
        verified_recruiting
      }
      
      it_behaves_like "is invalid"
    end

    context 'without user_id' do
      let(:verified_recruiting) { build(:valid_recruiting, user_id: nil) }
      it_behaves_like "is invalid"
    end

    context 'with invalid type' do
      let(:verified_recruiting) { build(:valid_recruiting, type: 'invalid_type') }
      it_behaves_like "is invalid"
    end

    context 'without type' do
      let(:verified_recruiting) { build(:valid_recruiting, type: nil) }
      it_behaves_like "is invalid"
    end

    context 'without recruitment_numbers' do
      let(:verified_recruiting) { build(:valid_recruiting, recruitment_numbers: nil) }
      it_behaves_like "is invalid"
    end

    context 'with overly long comment' do
      let(:verified_recruiting) { build(:valid_recruiting, comment: 'a'*300) }
      it_behaves_like "is invalid"
      it_behaves_like "include error message", 'は255文字以下にしてください', 'comment'.to_sym
    end

    context 'with overly long play_style' do
      let(:verified_recruiting) { build(:valid_recruiting, play_style: 'a'*33) }
      it_behaves_like "is invalid"
      it_behaves_like "include error message", 'は32文字以下にしてください', 'play_style'.to_sym
    end


    context 'if the number of participants exceeds recruitment_numbers at the time of update' do
      let(:verified_recruiting) { create(:valid_recruiting, :recruiting_is_filled) }

      it 'return errors' do
        verified_recruiting.reload.update(recruitment_numbers: 1)
        expect(verified_recruiting.reload.errors[:recruitment_numbers]).to include '既に参加しているメンバー数未満の値には設定できません。'
      end
    end


    context 'when changing recruiting from close to open' do
      context 'if recruiting was filled' do
        let(:verified_recruiting) { create(:valid_recruiting, :recruiting_is_filled) }

        it 'return errors' do
          verified_recruiting.reload.update(status: 'open')
          expect(verified_recruiting.reload.errors[:status]).to include 'この募集は満員状態なので公開できません。募集人数を再設定するか、新しく募集を作成してください'
        end
      end

      context 'if recruiting was closed' do
        let(:verified_recruiting) { create(:valid_recruiting) }

        it 'return errors' do
          verified_recruiting.update(status: 'open')
          expect(verified_recruiting.reload.status).to eq 'open'
        end
      end
    end
  end



  # ============= #
  #    relation   #
  # ============= #
  describe 'about relation' do

    context 'when delete user' do
      let(:created_valid_recruiting) { create(:valid_recruiting) }
      before { created_valid_recruiting }

      it 'delete recruiting too' do 
        count = Recruiting.all.count
        created_valid_recruiting.user.destroy
        expect(Recruiting.all.count).to eq (count - 1)
      end
    end

  end



  # ============= #
  #    callback   #
  # ============= #
  describe 'about callback' do

    context 'if increase recruitment_numbers' do
      context 'if recruiting was filled' do
        let(:update_recruiting) { create(:valid_recruiting, :recruiting_is_filled) }

        it 'update status to open' do
          update_recruiting.reload.update(recruitment_numbers: 3)
          expect(update_recruiting.reload.status).to eq 'open'
        end
      end

      context 'if recruiting was closed' do
        let(:update_recruiting) { create(:valid_recruiting, :recruiting_is_filled) }
        before { update_recruiting.reload.close! }
        it 'remain status' do
          update_recruiting.reload.update(recruitment_numbers: 3)
          expect(update_recruiting.reload.status).to eq 'close'
        end
      end
    end


    context 'if update status to close or filled' do
      context 'case of filled' do
        let(:update_recruiting) { create(:valid_recruiting, :recruiting_with_applicant) }
        before { 
          update_recruiting.applicants << create(:valid_users)
          update_recruiting.reload.applicant_entry_recruitings[0].approved!
          update_recruiting.reload.applicant_entry_recruitings[1].approved!
        }

        it 'destroy unapproved entries' do
          expect(update_recruiting.reload.applicants.length).to eq 2
        end
      end

      context 'case of closed' do
        let(:update_recruiting) { create(:valid_recruiting, :recruiting_with_applicant) }
        before { update_recruiting.close! }

        it 'destroy unapproved entries' do
          expect(update_recruiting.reload.applicants.length).to eq 0
        end
      end
    end

  end
  # ============= #
  #    scope      #
  # ============= #
  describe 'status_open' do
    let(:created_valid_recruiting) { create(:valid_recruiting) }
    before { created_valid_recruiting }

    it 'return valid value' do 
      expect(Recruiting.status_open[0].status).to eq created_valid_recruiting.status
    end
  end


  describe 'apex_type' do
    let(:created_valid_recruiting) { create(:valid_recruiting) }
    before { created_valid_recruiting }

    it 'return valid value' do 
      expect(Recruiting.apex_type[0].type).to eq created_valid_recruiting.type
    end
  end

  

  # ============= #
  #    method     #
  # ============= #

  describe 'vc(enum)' do
    let(:verified_recruiting) { build(:valid_recruiting, vc: vc) }
    where(:vc, :return_value) do
      [
        [nil, nil],
        [0, 'off'],
        [1, 'on']
      ]
    end

    with_them do
      it 'return valid value' do 
        expect(verified_recruiting.vc).to eq return_value
      end
    end  
  end

  
  describe 'status(enum)' do
    let(:verified_recruiting) { build(:valid_recruiting, status: status) }
    where(:status, :return_value) do
      [
        [nil, nil],
        [0, 'open'],
        [1, 'close'],
        [2, 'filled']
      ]
    end

    with_them do
      it 'return valid value' do 
        expect(verified_recruiting.status).to eq return_value
      end
    end  
  end


  describe 'search method' do
    let(:created_valid_recruiting) { create(:valid_recruiting) }
    let(:params) {
      { 
        search: {
          type: 'ApexRecruiting',
          rank: created_valid_recruiting.rank,
          game_mode: created_valid_recruiting.game_mode
        }
      }
    }
    before { created_valid_recruiting }
      
    it 'return valid search results' do 
      resluts = Recruiting.search(params)
      expect(resluts[0].id).to eq created_valid_recruiting.id
    end
  end


  describe 'owner?_method' do
    let(:created_valid_recruiting) { create(:valid_recruiting) }
    let(:owner) {created_valid_recruiting.user}
    let(:not_owner){ create(:valid_users) }
    before { created_valid_recruiting }

    context 'if user is owner' do 
      it 'return true' do
        expect(created_valid_recruiting.owner?(owner)).to eq true
      end
    end

    context 'if user is not owner' do 
      it 'return false' do
        expect(created_valid_recruiting.owner?(not_owner)).to eq false
      end
    end
  end
end
