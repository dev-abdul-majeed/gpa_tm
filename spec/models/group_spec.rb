require 'rails_helper'

RSpec.describe Group, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:course) }

    it do
      is_expected.to have_many(:group_memberships).dependent(:destroy)
    end

    it do
      is_expected.to have_many(:students)
        .through(:group_memberships)
        .source(:student)
    end

    it do
      is_expected.to have_many(:assignment_group_scores).dependent(:destroy)
    end

    it do
      is_expected.to have_many(:final_marks).dependent(:destroy)
    end
  end

  describe 'validations' do
    let(:course) { create(:course) }
    subject { build(:group, course: course) }

    it { is_expected.to validate_presence_of(:group_name) }
    it do
      is_expected.to validate_uniqueness_of(:group_name)
        .scoped_to(:course_id)
    end
  end

  describe 'instance methods' do
    let(:school) { create(:school) }
    let(:teacher) { create(:teacher, school: school) }
    let(:course) { create(:course, teacher: teacher) }
    let(:group) { create(:group, course: course) }
    let(:student1) { create(:student, school: school) }
    let(:student2) { create(:student, school: school) }
    let(:other_course) { create(:course, teacher: teacher) }
    let(:other_group) { create(:group, course: other_course) }

    before do
      course.students << [student1, student2]
    end

    describe '#add_student' do
      context 'when student is not in any group for the course' do
        it 'adds the student to the group' do
          expect {
            group.add_student(student1)
          }.to change { group.students.count }.by(1)
        end

        it 'creates a group membership' do
          expect {
            group.add_student(student1)
          }.to change { GroupMembership.count }.by(1)
        end
      end

      context 'when student is already in another group for the course' do
        let(:group2) { create(:group, course: course) }

        before do
          group2.add_student(student1)
        end

        it 'removes student from previous group and adds to new group' do
          expect {
            group.add_student(student1)
          }.to change { group.students.count }.by(1)
            .and change { group2.students.count }.by(-1)
        end
      end

      context 'when student is already in this group' do
        before do
          group.add_student(student1)
        end

        it 'does not create duplicate membership' do
          expect {
            group.add_student(student1)
          }.not_to change { GroupMembership.count }
        end
      end
    end
  end

  describe 'dependent behavior' do
    let(:school) { create(:school) }
    let(:teacher) { create(:teacher, school: school) }
    let(:course) { create(:course, teacher: teacher) }
    let(:group) { create(:group, course: course) }
    let(:student) { create(:student, school: school) }
    let!(:group_membership) { create(:group_membership, group: group, student: student) }

    it 'destroys associated group memberships when group is destroyed' do
      expect { group.destroy }.to change { GroupMembership.count }.by(-1)
    end
  end
end
