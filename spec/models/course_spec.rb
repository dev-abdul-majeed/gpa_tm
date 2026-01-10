require 'rails_helper'

RSpec.describe Course, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:teacher).class_name('Teacher') }

    it do
      is_expected.to have_many(:groups).dependent(:destroy)
    end

    it do
      is_expected.to have_many(:group_memberships)
        .through(:groups)
        .dependent(:destroy)
    end

    it do
      is_expected.to have_many(:assignments).dependent(:destroy)
    end

    it do
      is_expected.to have_and_belong_to_many(:students)
        .class_name('Student')
        .join_table(:course_students)
    end
  end

  describe 'validations' do
    subject { build(:course) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:description) }
  end

  describe 'alias_attribute' do
    it 'aliases course_teacher_id to teacher_id' do
      course = build(:course)
      expect(course).to respond_to(:course_teacher_id)
      expect(course).to respond_to(:course_teacher_id=)
    end
  end

  describe 'instance methods' do
    let(:school) { create(:school) }
    let(:teacher) { create(:teacher, school: school) }
    let(:course) { create(:course, teacher: teacher) }
    let(:student1) { create(:student, school: school) }
    let(:student2) { create(:student, school: school) }
    let(:student3) { create(:student, school: school) }
    let(:group) { create(:group, course: course) }

    before do
      course.students << [student1, student2, student3]
      group.students << [student1, student2]
    end

    describe '#students_in_groups' do
      it 'returns students who are in groups for this course' do
        students_in_groups = course.students_in_groups
        expect(students_in_groups).to include(student1, student2)
        expect(students_in_groups).not_to include(student3)
      end
    end

    describe '#students_without_groups' do
      it 'returns students not in any group for this course' do
        students_without_groups = course.students_without_groups
        expect(students_without_groups).to include(student3)
        expect(students_without_groups).not_to include(student1, student2)
      end
    end
  end

  describe 'dependent behavior' do
    let(:school) { create(:school) }
    let(:teacher) { create(:teacher, school: school) }
    let(:course) { create(:course, teacher: teacher) }
    let!(:group) { create(:group, course: course) }
    let!(:assignment) { create(:assignment, course: course) }

    it 'destroys associated groups when course is destroyed' do
      expect { course.destroy }.to change { Group.count }.by(-1)
    end

    it 'destroys associated assignments when course is destroyed' do
      expect { course.destroy }.to change { Assignment.count }.by(-1)
    end
  end
end
