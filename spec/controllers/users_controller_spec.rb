require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  it { should use_before_filter(:require_user) }

  before(:each) do
    password = 'test1234567890'
    u = User.create!(
      first_name: 'bob',
      email: 'test@test.com',
      password: password,
      password_confirmation: password
    )
    allow_any_instance_of(ApplicationController).to(
      receive(:current_user).and_return(u)
    )
  end

  after(:each) do
    User.all.each(&:delete)
  end

  it 'renders the new template' do
    get :new
    expect(assigns(:user)).to be_a_new(User)
    expect(response).to render_template('new')
  end

  it 'renders the password reset template' do
    get :password_reset
    expect(assigns(:user)).not_to be_a_new(User)
    expect(response).to render_template('password_reset')
  end

  it 'creates the user and redirects to root' do
    post :create, user: {
      first_name: 'Billy',
      email: 'test2@test.com',
      password: 'test1234567890',
      password_confirmation: 'test1234567890'
    }
    expect(assigns(:user)).not_to be_a_new(User)
    expect(response).to redirect_to(root_path)
  end

  it 'fails to create the user and renders new' do
    post :create, user: {
      first_name: 'Billy',
      email: 'test2@test.com',
      password: 'test1234567890',
      password_confirmation: 'fdf13fardsfafasdf'
    }
    expect(assigns(:user)).to be_a_new(User)
    expect(response).to render_template('new')
  end

  it 'fails to set password for the user and renders password reset with mismatch passwords' do
    patch :set_password, user: {
      password: 'test1234567890',
      password_confirmation: 'fdf13fardsfafasdf'
    }
    expect(assigns(:user)).not_to be_a_new(User)
    expect(response).to render_template('password_reset')
  end

  it 'fails to set password for the user and renders password reset with short passwords' do
    patch :set_password, user: {
      password: '12345',
      password_confirmation: '12345'
    }
    expect(assigns(:user)).not_to be_a_new(User)
    expect(response).to render_template('password_reset')
  end

  it 'sets the password for the user and redirects to root' do
    patch :set_password, user: {
      password: '1234567890',
      password_confirmation: '1234567890'
    }
    expect(assigns(:user)).not_to be_a_new(User)
    expect(response).to redirect_to(root_path)
  end
end
