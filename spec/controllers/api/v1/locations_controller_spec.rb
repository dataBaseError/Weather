require 'rails_helper'

RSpec.describe Api::V1::LocationsController, type: :controller do
  it 'renders empty json array for a non country' do
    get :states, country: 'Not Present'
    expect(response.body).to eq([].to_json)
  end

  it 'renders json of states for a given country' do
    get :states, country: 'CA'
    expect(response.body).to eq(CS.get(:CA).to_a.map(&:reverse).to_json)
  end

  it 'renders json of cities for a given country and state' do
    get :cities, country: 'CA', state: 'Not Present'
    expect(response.body).to eq([].to_json)
  end

  it 'renders json of cities for a given country and state' do
    get :cities, country: 'CA', state: 'ON'
    expect(response.body).to eq(CS.get(:CA, :ON).map { |c| [c, c] }.to_json)
  end
end
