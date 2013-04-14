require 'spec_helper'

describe "Create project" do

  before 'Sign in' do
    visit '/users/sign_in'

    fill_in "user[email]",                 with: "user@example.com"
    fill_in "user[password]",              with: "password"
    click_button 'Sign in'
  end

  it 'should be / page' do
    page.should have_content('Progress')
  end

  it 'should work link for create' do
    page.find(  'i.icon-leaf.green' ).click
    page.should have_css '.add_new_project_field'
  end

  it 'should show error message if field empty' do
    page.find(  'i.icon-leaf.green' ).click

    click_button 'Save'
    page.should have_css '.alert-error'
  end

  it 'should be success' do
    page.find(  'i.icon-leaf.green' ).click

    fill_in "project[name]",                 with: "test name"
    fill_in "project[desc]",              with: "test desc"

    click_button 'Save'

    page.should have_selector('title', :text => 'test name - Abulafia')
  end


end