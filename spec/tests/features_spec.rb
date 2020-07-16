require 'rails_helper'

RSpec.describe 'Sign Up, Log In and desktop features', type: :feature do
  before :each do
    User.create(username: 'John', fullname: 'John Kennedy')
  end

  it 'Signs up new user' do
    visit '/users/new'
    fill_in 'user_username', with: 'Jimmy'
    fill_in 'user_fullname', with: 'Jimmy Henrix'

    click_button 'Create User'
    user = User.last
    expect(user.username).to have_content('Jimmy')
  end

  it 'Tries to Sign up without fullname' do
    visit '/users/new'
    fill_in 'user_username', with: 'Jimmy'

    click_button 'Create User'
    expect(page).to have_content('Fullname can\'t be blank')
  end

  it 'Log in a user' do
    visit '/sessions/new'
    fill_in 'username', with: 'John'

    click_button 'Login'
    sleep(3)
    expect(page).to have_content('John')
  end

  it 'Tries to Log in with wrong username' do
    visit '/sessions/new'
    fill_in 'username', with: 'Eric'

    click_button 'Login'
    expect(page).to have_content('Wrong User Name')
  end

  it 'Logs in and adds 3 opinions' do
    visit '/sessions/new'
    fill_in 'username', with: 'John'

    click_button 'Login'
    sleep(1)
    fill_in 'opinion[text]', with: 'Let me say that one of the nicest things about London is the people.\n'
    click_button 'Save'
    sleep(1)
    expect(Opinion.all.count).to eq(1)
    fill_in 'opinion[text]', with: 'Let me say that one of the nicest things about London is the people.\n'
    click_button 'Save'
    sleep(1)
    expect(Opinion.all.count).to eq(2)
    fill_in 'opinion[text]', with: 'Let me say that one of the nicest things about London is the people.\n'
    click_button 'Save'
    sleep(1)
    expect(Opinion.all.count).to eq(3)
  end
end
