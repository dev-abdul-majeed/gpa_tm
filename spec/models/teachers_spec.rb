require 'rails_helper'

RSpec.describe Teacher, type: :model do
  describe 'inheritance' do
    it 'inherits from User' do
      expect(Teacher.superclass).to eq(User)
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:school) }

    it do
      is_expected.to have_many(:courses)
        .dependent(:destroy)
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:school) }
  end

  describe 'dependent behavior' do
    let(:school)  { create(:school) }
    let(:teacher) { create(:teacher, school: school) }
    let!(:course) { create(:course, course_teacher_id: teacher.id) }

    it 'destroys associated courses when teacher is destroyed' do
      expect { teacher.destroy }.to change { Course.count }.by(-1)
    end
  end
end
