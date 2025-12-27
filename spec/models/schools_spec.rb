require 'rails_helper'

RSpec.describe School, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:teachers).class_name('Teacher').dependent(:nullify) }
    it { is_expected.to have_many(:students).class_name('Student').dependent(:nullify) }
    it { is_expected.to have_one(:admin).class_name('Admin').dependent(:nullify) }
  end

  describe 'validations' do
    subject { build(:school) } # for uniqueness validation

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(100) }

    it { is_expected.to validate_presence_of(:location) }
    it { is_expected.to validate_length_of(:location).is_at_most(150) }

    it { is_expected.to validate_presence_of(:domain) }
    it { is_expected.to validate_length_of(:domain).is_at_most(100) }
  end
end
