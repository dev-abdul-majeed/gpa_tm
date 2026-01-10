require 'rails_helper'

RSpec.describe AssignmentGroupScore, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:assignment) }
    it { is_expected.to belong_to(:group).optional }

    it do
      is_expected.to have_many(:final_marks)
        .dependent(:restrict_with_error)
    end
  end

  describe 'validations' do
    subject { build(:assignment_group_score) }

    it { is_expected.to validate_presence_of(:group_score) }
    it do
      is_expected.to validate_numericality_of(:group_score)
        .is_greater_than_or_equal_to(0)
    end

    it { is_expected.to validate_presence_of(:assignment) }
  end

  describe 'custom validations' do
    let(:school) { create(:school) }
    let(:teacher) { create(:teacher, school: school) }
    let(:course) { create(:course, teacher: teacher) }
    let(:assignment) { create(:assignment, course: course) }
    let(:group) { create(:group, course: course) }

    context 'when group belongs to assignment course' do
      it 'is valid' do
        score = build(:assignment_group_score, assignment: assignment, group: group)
        expect(score).to be_valid
      end
    end

    context 'when group does not belong to assignment course' do
      let(:other_course) { create(:course, teacher: teacher) }
      let(:wrong_group) { create(:group, course: other_course) }

      it 'is invalid' do
        score = build(:assignment_group_score, assignment: assignment, group: wrong_group)
        expect(score).to be_invalid
        expect(score.errors[:group])
          .to include('must belong to the same course as the assignment')
      end
    end

    context 'when group is nil' do
      it 'is valid' do
        score = build(:assignment_group_score, assignment: assignment, group: nil)
        expect(score).to be_valid
      end
    end
  end

  describe 'scopes' do
    let(:school) { create(:school) }
    let(:teacher) { create(:teacher, school: school) }
    let(:course) { create(:course, teacher: teacher) }
    let(:assignment) { create(:assignment, course: course) }
    let(:group) { create(:group, course: course) }

    describe '.for_assignment' do
      let!(:score1) { create(:assignment_group_score, assignment: assignment) }
      let!(:score2) { create(:assignment_group_score, assignment: assignment, group: group) }
      let(:other_assignment) { create(:assignment, course: course) }
      let!(:score3) { create(:assignment_group_score, assignment: other_assignment) }

      it 'returns scores for the specified assignment' do
        expect(AssignmentGroupScore.for_assignment(assignment)).to include(score1, score2)
        expect(AssignmentGroupScore.for_assignment(assignment)).not_to include(score3)
      end
    end

    describe '.for_group' do
      let!(:score1) { create(:assignment_group_score, assignment: assignment, group: group) }
      let!(:score2) { create(:assignment_group_score, assignment: assignment, group: nil) }
      let(:other_group) { create(:group, course: course) }
      let!(:score3) { create(:assignment_group_score, assignment: assignment, group: other_group) }

      it 'returns scores for the specified group' do
        expect(AssignmentGroupScore.for_group(group)).to include(score1)
        expect(AssignmentGroupScore.for_group(group)).not_to include(score2, score3)
      end
    end

    describe '.defaults' do
      let!(:default_score) { create(:assignment_group_score, assignment: assignment, group: nil) }
      let!(:group_score) { create(:assignment_group_score, assignment: assignment, group: group) }

      it 'returns only default scores (group_id is nil)' do
        expect(AssignmentGroupScore.defaults).to include(default_score)
        expect(AssignmentGroupScore.defaults).not_to include(group_score)
      end
    end

    describe '.group_specific' do
      let!(:default_score) { create(:assignment_group_score, assignment: assignment, group: nil) }
      let!(:group_score) { create(:assignment_group_score, assignment: assignment, group: group) }

      it 'returns only group-specific scores' do
        expect(AssignmentGroupScore.group_specific).to include(group_score)
        expect(AssignmentGroupScore.group_specific).not_to include(default_score)
      end
    end
  end

  describe 'instance methods' do
    let(:school) { create(:school) }
    let(:teacher) { create(:teacher, school: school) }
    let(:course) { create(:course, teacher: teacher) }
    let(:assignment) { create(:assignment, course: course) }
    let(:group) { create(:group, course: course) }

    describe '#default?' do
      context 'when group_id is nil' do
        let(:score) { build(:assignment_group_score, assignment: assignment, group: nil) }

        it 'returns true' do
          expect(score.default?).to be true
        end
      end

      context 'when group_id is present' do
        let(:score) { build(:assignment_group_score, assignment: assignment, group: group) }

        it 'returns false' do
          expect(score.default?).to be false
        end
      end
    end

    describe '#group_specific?' do
      context 'when group_id is nil' do
        let(:score) { build(:assignment_group_score, assignment: assignment, group: nil) }

        it 'returns false' do
          expect(score.group_specific?).to be false
        end
      end

      context 'when group_id is present' do
        let(:score) { build(:assignment_group_score, assignment: assignment, group: group) }

        it 'returns true' do
          expect(score.group_specific?).to be true
        end
      end
    end
  end

  describe 'class methods' do
    let(:school) { create(:school) }
    let(:teacher) { create(:teacher, school: school) }
    let(:course) { create(:course, teacher: teacher) }
    let(:assignment) { create(:assignment, course: course) }
    let(:group) { create(:group, course: course) }

    describe '.find_or_initialize_for' do
      context 'when group-specific score exists' do
        let!(:group_score) do
          create(:assignment_group_score, assignment: assignment, group: group, group_score: 0.9)
        end

        it 'returns the group-specific score' do
          result = AssignmentGroupScore.find_or_initialize_for(assignment, group)
          expect(result).to eq(group_score)
          expect(result).to be_persisted
        end
      end

      context 'when group-specific score does not exist but default exists' do
        let!(:default_score) do
          create(:assignment_group_score, assignment: assignment, group: nil, group_score: 0.8)
        end

        it 'returns the default score' do
          result = AssignmentGroupScore.find_or_initialize_for(assignment, group)
          expect(result).to eq(default_score)
          expect(result).to be_persisted
        end
      end

      context 'when no scores exist' do
        it 'returns a new default score' do
          result = AssignmentGroupScore.find_or_initialize_for(assignment, group)
          expect(result).to be_new_record
          expect(result.assignment).to eq(assignment)
          expect(result.group).to be_nil
        end
      end

      context 'when group is nil' do
        it 'returns a new default score' do
          result = AssignmentGroupScore.find_or_initialize_for(assignment, nil)
          expect(result).to be_new_record
          expect(result.assignment).to eq(assignment)
          expect(result.group).to be_nil
        end
      end
    end
  end

  describe 'callbacks' do
    let(:school) { create(:school) }
    let(:teacher) { create(:teacher, school: school) }
    let(:course) { create(:course, teacher: teacher) }
    let(:assignment) { create(:assignment, course: course) }

    describe 'before_save :set_timestamp' do
      context 'when group_score changes' do
        let(:score) { create(:assignment_group_score, assignment: assignment, group_score: 0.8, set_at: nil) }

        it 'sets set_at timestamp' do
          freeze_time do
            score.update(group_score: 0.9)
            expect(score.set_at).to eq(Time.current)
          end
        end
      end

      context 'when group_score does not change' do
        let(:score) { create(:assignment_group_score, assignment: assignment, group_score: 0.8, set_at: 1.day.ago) }

        it 'does not override existing set_at' do
          old_time = score.set_at
          score.update(assignment: assignment)
          expect(score.set_at).to eq(old_time)
        end
      end
    end
  end
end
