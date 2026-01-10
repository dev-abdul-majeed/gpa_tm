require 'rails_helper'

RSpec.describe SuperAdmin, type: :model do
  describe 'inheritance' do
    it 'inherits from User' do
      expect(SuperAdmin.superclass).to eq(User)
    end
  end
end
