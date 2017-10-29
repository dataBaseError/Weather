require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:email) }

  it { should have_many(:histories) }

  it 'should have a location' do
    u = User.create(
      email: 'test@test.com',
      country: 'US',
      city: 'New York'
    )
    expect(u.location?).to eq(true)
  end

  it 'should not have a location' do
    u = User.create(
      email: 'test@test.com'
    )
    expect(u.location?).to eq(false)
  end
end
