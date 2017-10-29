require 'rails_helper'

RSpec.describe UserSessionsController, type: :controller do
  it { should use_before_filter(:require_user) }

  before(:each) do
    @password = 'test1234567890'
    @u = User.create!(
      first_name: 'bob',
      email: 'test@test.com',
      password: @password,
      password_confirmation: @password
    )

    @random_history = {}
    allow_any_instance_of(Redis).to(
      receive(:hset) do |_, _hkey, field, value|
        @random_history[field] = value
      end
    )
  end

  after(:each) do
    User.all.each(&:delete)
  end

  it 'renders the new template' do
    get :new
    expect(assigns(:user_session)).to be_a_new(UserSession)
    expect(response).to render_template('new')
  end

  it 'creates user session and redirects to sign root' do
    patch(
      :create,
      user_session: {
        email: 'test@test.com',
        password: @password,
        remember_me: false
      }
    )
    expect(@random_history).to eq(@u.email => {}.to_json)
    expect(assigns(:user_session)).not_to be_a_new(UserSession)
    expect(response).to redirect_to(root_path)
  end

  it 'creates user session and redirects to sign root' do
    patch(
      :create,
      user_session: {
        email: 'test@test.com',
        password: @password,
        remember_me: false
      }
    )
    expect(@random_history).to eq(@u.email => {}.to_json)
    expect(assigns(:user_session)).not_to be_a_new(UserSession)
    expect(response).to redirect_to(root_path)
  end
end
