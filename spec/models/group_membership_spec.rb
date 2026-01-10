require 'rails_helper'

RSpec.describe GroupMembership, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:group) }
    it do
      is_expected.to belong_to(:student)
        .class_name('Student')
        .with_foreign_key('student_id')
    end
  end

  describe 'custom validations' do
    let(:school) { create(:school) }
    let(:teacher) { create(:teacher, school: school) }
    let(:course) { create(:course, teacher: teacher) }
    let(:group1) { create(:group, course: course) }
    let(:group2) { create(:group, course: course) }
    let(:student) { create(:student, school: school) }

    before do
      course.students << student
    end

    context 'when student is already in another group for the same course' do
      before do
        create(:group_membership, group: group1, student: student)
      end

      it 'is invalid' do
        membership = build(:group_membership, group: group2, student: student)
        expect(membership).to be_invalid
        expect(membership.errors[:student])
          .to include('can only belong to one group per course')
      end
    end

    context 'when student is in a group for a different course' do
      let(:other_course) { create(:course, teacher: teacher) }
      let(:other_group) { create(:group, course: other_course) }

      before do
        other_course.students << student
        create(:group_membership, group: other_group, student: student)
      end

      it 'is valid' do
        membership = build(:group_membership, group: group1, student: student)
        expect(membership).to be_valid
      end
    end

    context 'when student is not in any group for the course' do
      it 'is valid' do
        membership = build(:group_membership, group: group1, student: student)
        expect(membership).to be_valid
      end
    end

    context 'when updating existing membership' do
      let!(:membership) { create(:group_membership, group: group1, student: student) }

      it 'does not validate against itself' do
        membership.group = group1
        expect(membership).to be_valid
      end
    end
  end
end
