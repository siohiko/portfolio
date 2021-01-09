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
      let(:verified_recruiting) { create(:valid_recruiting, :recruiting_with_applicant) }
      let(:applicants) { verified_recruiting.applicant_entry_recruitings }
      before {
        verified_recruiting.applicant_entry_recruitings.each do |entry|
          entry.approved!
        end
      }

      it 'return errors' do
        verified_recruiting.update(recruitment_numbers: 1)
        expect(verified_recruiting.errors[:recruitment_numbers]).to include '既に参加者しているメンバー数以下の値には設定できません。'
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
