require 'rails_helper'

RSpec.describe Assignment, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:course) }

    it { is_expected.to have_many(:peer_marks).dependent(:destroy) }
    it { is_expected.to have_many(:peer_mark_submissions).dependent(:destroy) }
    it { is_expected.to have_many(:assignment_group_scores).dependent(:destroy) }
    it { is_expected.to have_many(:final_marks).dependent(:destroy) }
  end

  describe 'validations' do
    subject { build(:assignment) }

    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_length_of(:title).is_at_most(50) }

    it { is_expected.to validate_presence_of(:assignment_type) }
    it do
      is_expected.to validate_inclusion_of(:assignment_type)
        .in_array(%w[qass webavalia])
    end

    it { is_expected.to validate_presence_of(:rating_scale) }
    it do
      is_expected.to validate_numericality_of(:rating_scale)
        .only_integer
        .is_greater_than_or_equal_to(0)
        .is_less_than_or_equal_to(100)
    end

    it do
      is_expected.to validate_inclusion_of(:rating_model)
        .in_array(%w[B C D])
    end

    it do
      is_expected.to validate_numericality_of(:self_rating_weight)
        .is_greater_than_or_equal_to(0.0)
        .is_less_than_or_equal_to(100.0)
    end

    it { is_expected.to validate_presence_of(:start_date_time) }
    it { is_expected.to validate_presence_of(:end_date_time) }
  end

  describe 'custom validations' do
    let(:assignment) { build(:assignment) }

    context 'when end_date_time is before start_date_time' do
      it 'is invalid' do
        assignment.start_date_time = Time.current
        assignment.end_date_time   = 1.hour.ago

        expect(assignment).to be_invalid
        expect(assignment.errors[:end_date_time])
          .to include('must be after start date time')
      end
    end

    context 'when end_date_time equals start_date_time' do
      it 'is invalid' do
        time = Time.current
        assignment.start_date_time = time
        assignment.end_date_time   = time

        expect(assignment).to be_invalid
        expect(assignment.errors[:end_date_time])
          .to include('must be after start date time')
      end
    end

    context 'when end_date_time is after start_date_time' do
      it 'is valid' do
        assignment.start_date_time = Time.current
        assignment.end_date_time   = 2.hours.from_now

        expect(assignment).to be_valid
      end
    end
  end

  describe 'callbacks' do
    context 'before_validation on create' do
      it 'sets default rating_model to B if nil' do
        assignment = build(:assignment, rating_model: nil)

        assignment.valid?

        expect(assignment.rating_model).to eq('B')
      end

      it 'does not override rating_model if already set' do
        assignment = build(:assignment, rating_model: 'C')

        assignment.valid?

        expect(assignment.rating_model).to eq('C')
      end
    end
  end

  describe '#qass?' do
    it 'returns true when assignment_type is qass' do
      assignment = build(:assignment, assignment_type: 'qass')
      expect(assignment.qass?).to be true
    end

    it 'returns false when assignment_type is not qass' do
      assignment = build(:assignment, assignment_type: 'webavalia')
      expect(assignment.qass?).to be false
    end
  end

  describe '#webavalia?' do
    it 'returns true when assignment_type is webavalia' do
      assignment = build(:assignment, assignment_type: 'webavalia')
      expect(assignment.webavalia?).to be true
    end

    it 'returns false when assignment_type is not webavalia' do
      assignment = build(:assignment, assignment_type: 'qass')
      expect(assignment.webavalia?).to be false
    end
  end
end
