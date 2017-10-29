require 'rails_helper'

RSpec.describe PreferencesController, type: :controller do
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
    get :details
    expect(response).to render_template('details')
  end

  it 'renders the index template' do
    post(
      :details_update,
      detail: {
        country: 'CA',
        state: 'ON',
        city: 'Toronto'
      }
    )
    expect(assigns(:user)).not_to be_a_new(User)
    expect(response).to redirect_to(root_path)
  end
end
