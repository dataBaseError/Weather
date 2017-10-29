require 'rails_helper'

RSpec.describe History, type: :model do
  it { should validate_presence_of(:search_param) }
  it { should validate_presence_of(:city) }

  it { should validate_presence_of(:country) }
  it { should validate_presence_of(:weather_type) }
  it { should validate_presence_of(:tempature) }

  it { should belong_to(:user) }
end
