require 'rails_helper'

RSpec.describe Admin, type: :model do
  describe 'inheritance' do
    it 'inherits from User' do
      expect(Admin.superclass).to eq(User)
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:school) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:school) }
  end
end
