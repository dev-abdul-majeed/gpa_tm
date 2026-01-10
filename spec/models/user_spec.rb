require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject { build(:user) }

    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_length_of(:first_name).is_at_most(50) }

    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_length_of(:last_name).is_at_most(50) }

    it { is_expected.to validate_presence_of(:gender) }
    it { is_expected.to validate_length_of(:gender).is_at_most(10) }
    it do
      is_expected.to validate_inclusion_of(:gender)
        .in_array(%w[Male Female Other])
    end

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_length_of(:email).is_at_most(150) }

    it { is_expected.to validate_presence_of(:date_of_birth) }
    it { is_expected.to validate_presence_of(:type) }
  end

  describe 'devise modules' do
    it { is_expected.to respond_to(:email) }
    it { is_expected.to respond_to(:encrypted_password) }
    it { is_expected.to respond_to(:reset_password_token) }
    it { is_expected.to respond_to(:remember_created_at) }
  end

  describe 'instance methods' do
    let(:user) { build(:user, first_name: 'John', last_name: 'Doe') }

    describe '#full_name' do
      it 'returns the concatenated first and last name' do
        expect(user.full_name).to eq('John Doe')
      end
    end

    describe '#teacher?' do
      context 'when type is Teacher' do
        let(:teacher) { build(:teacher) }

        it 'returns true' do
          expect(teacher.teacher?).to be true
        end
      end

      context 'when type is not Teacher' do
        let(:student) { build(:student) }

        it 'returns false' do
          expect(student.teacher?).to be false
        end
      end
    end

    describe '#student?' do
      context 'when type is Student' do
        let(:student) { build(:student) }

        it 'returns true' do
          expect(student.student?).to be true
        end
      end

      context 'when type is not Student' do
        let(:teacher) { build(:teacher) }

        it 'returns false' do
          expect(teacher.student?).to be false
        end
      end
    end
  end
end
