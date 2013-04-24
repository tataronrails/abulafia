require 'spec_helper'

describe "Register page " do

  it 'should be sign up page' do
    visit new_user_registration_path
    page.should have_content('Sign up')
  end

  describe 'Fill inputs' do
    before { visit new_user_registration_path }

    it 'should be error if Email doesn\'t fill' do
      click_button 'Sign up'
      page.should have_content 'Email can\'t be blank'
    end

    it 'should be error if FirstName doesn\'t fill' do
      click_button 'Sign up'
      page.should have_content 'First name can\'t be blank'
    end

    it 'should be error if Second name doesn\'t fill' do
      click_button 'Sign up'
      page.should have_content 'Second name can\'t be blank'
    end

    it 'should be error if Login doesn\'t fill' do
      click_button 'Sign up'
      page.should have_content 'Login can\'t be blank'
    end

    it 'should be error if Initials doesn\'t fill' do
      click_button 'Sign up'
      page.should have_content 'Initials can\'t be blank'
    end

    it 'should be error if Skype doesn\'t fill' do
      click_button 'Sign up'
      page.should have_content 'Im can\'t be blank'
    end

    it 'should be error if Password doesn\'t fill' do
      click_button 'Sign up'
      page.should have_content 'Password can\'t be blank'
    end

    it 'Password should match' do
      fill_in "Password",              with: "foobar"
      fill_in "Password confirmation", with: "foobar2"
      click_button 'Sign up'
      page.should have_content 'Password doesn\'t match confirmation'
    end

    it 'Should be success' do
      fill_in "Email",                 with: "test@example.com"
      fill_in "First name",            with: "first name"
      fill_in "Second name",           with: "second name"
      fill_in "Login",                 with: "login"
      fill_in "Initials",              with: "v.v."
      fill_in "Skype",                 with: "Test"
      fill_in "Password",              with: "foobar"
      fill_in "Password confirmation", with: "foobar"
      expect do
      click_button 'Sign up'
      end.to change(User, :count).by(1)
    end

  end
end