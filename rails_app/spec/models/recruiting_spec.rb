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
  #    method   #
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
        [1, 'close']
      ]
    end

    with_them do
      it 'return valid value' do 
        expect(verified_recruiting.status).to eq return_value
      end
    end  
  end

end