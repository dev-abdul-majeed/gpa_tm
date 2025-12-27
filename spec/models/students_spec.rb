# require 'rails_helper'

# RSpec.describe Group, type: :model do
#   let(:school) { FactoryBot.create(:school) }
#   let(:student) { FactoryBot.create(:student, school: school)}

#   it 'saffa' do
#     expect(student).to be_valid
#   end
# end

require 'rails_helper'

RSpec.describe Student, type: :model do
  describe 'inheritance' do
    it 'inherits from User' do
      expect(Student.superclass).to eq(User)
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:school) }

    it do
      is_expected.to have_and_belong_to_many(:courses)
        .class_name('Course')
        .join_table(:course_students)
    end

    it do
      is_expected.to have_many(:group_memberships)
        .with_foreign_key('student_id')
        .dependent(:destroy)
    end

    it { is_expected.to have_many(:groups).through(:group_memberships) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:school) }
  end

  describe 'instance methods' do
    let(:school)  { create(:school) }
    let(:student) { create(:student, school: school) }
    let(:teacher) { create(:teacher, school: school) }
    let(:course)  { create(:course, teacher: teacher) }

    describe '#group_for_course' do
      context 'when student is in a group for the course' do
        let(:group) { create(:group, course: course) }

        before do
          create(:group_membership, student: student, group: group)
        end

        it 'returns the group for the given course' do
          expect(student.group_for_course(course)).to eq(group)
        end
      end

      context 'when student is not in a group for the course' do
        it 'returns nil' do
          expect(student.group_for_course(course)).to be_nil
        end
      end
    end

    describe '#in_group_for_course?' do
      let(:group) { create(:group, course: course) }

      context 'when student is in a group for the course' do
        before do
          create(:group_membership, student: student, group: group)
        end

        it 'returns true' do
          expect(student.in_group_for_course?(course)).to be true
        end
      end

      context 'when student is not in a group for the course' do
        it 'returns false' do
          expect(student.in_group_for_course?(course)).to be false
        end
      end
    end
  end
end
