require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  it { should use_before_filter(:require_user) }

  before(:each) do
    @password = 'test1234567890'
    @u = User.create!(
      first_name: 'bob',
      email: 'test@test.com',
      password: @password,
      password_confirmation: @password
    )
    allow_any_instance_of(ApplicationController).to(
      receive(:require_user).and_return(true)
    )

    allow_any_instance_of(ApplicationController).to(
      receive(:current_user).and_return(@u)
    )
  end

  after(:each) do
    User.all.each(&:delete)
  end

  it 'renders the index template' do
    get :index
    expect(response).to render_template('index')
  end

  it 'renders the search template' do
    post :index, search: 'New York'
    expect(response).to render_template('search/index')
  end

  it 'renders the search template' do
    post :index
    expect(response).to render_template('search/index')
  end
end
