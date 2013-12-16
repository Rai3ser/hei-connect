require 'spec_helper'

feature 'Visitor signs up' do

  before :each do
    ResqueSpec.reset!
    sign_out
  end

  given(:valid_id)   { 'h01234' }
  given(:invalid_id) { 'kikoolol' }
  given(:password)   { 'password' }

  scenario 'with valid id and a password' do
    sign_in_with valid_id, password

    expect(page).to have_content 'Premier login'
    expect(CheckUserWorker).to have_queue_size_of 1
    expect(User.count).to be 1
  end

  scenario 'with blank id and password' do
    sign_in_with '', ''

    expect(page).to have_content 'Login'
  end

  scenario 'with invalid id' do
    sign_in_with invalid_id, password

    expect(page).to have_content 'Login'
  end

  scenario 'with blank password' do
    sign_in_with valid_id, ''

    expect(page).to have_content 'Login'
  end

end