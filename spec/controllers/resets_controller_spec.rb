require 'rails_helper'

RSpec.describe ResetsController, type: :controller do
  it { should use_before_filter(:require_no_user) }

  it { should use_before_filter(:load_user_using_perishable_token) }

  before(:each) do
    password = 'test1234567890'
    @u = User.create!(
      first_name: 'bob',
      email: 'test@test.com',
      password: password,
      password_confirmation: password
    )
    allow_any_instance_of(User).to(
      receive(:deliver_password_reset_instructions!).and_return(nil)
    )
    @u.reset_perishable_token!
  end

  after(:each) do
    User.all.each(&:delete)
  end

  it 'renders the new template' do
    get :new
    expect(response).to render_template('new')
  end

  it 'renders the edit template' do
    get :edit, id: @u.perishable_token
    expect(response).to render_template('edit')
  end

  it 'creates user password reset and redirects to sign in' do
    patch :create, email: 'test@test.com'
    expect(assigns(:user)).not_to be_a_new(User)
    expect(response).to redirect_to(root_path)
  end

  it 'updates user password and redirects to sign in' do
    patch(
      :update,
      id: @u.perishable_token,
      password: '1234567890',
      password_confirmation: '1234567890'
    )
    expect(assigns(:user)).not_to be_a_new(User)
    expect(response).to redirect_to(sign_in_path)
  end

  it 'failes to update user password and renders edit' do
    patch(
      :update,
      id: @u.perishable_token,
      password: '1234',
      password_confirmation: '1234'
    )
    expect(assigns(:user)).not_to be_a_new(User)
    expect(response).to render_template('edit')
  end

  it 'fails to render edit with invalid perishable token' do
    get :edit, id: '213456789'
    expect(response).to redirect_to(root_url)
  end

  it 'fails to update with invalid perishable token' do
    patch(
      :update,
      id: '1324567890',
      password: '1234567890',
      password_confirmation: '1234567890'
    )
    expect(assigns(:user)).not_to be_a_new(User)
    expect(response).to redirect_to(root_url)
  end
end
