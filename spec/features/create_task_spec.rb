require 'spec_helper'

describe "Task creation" do

  before 'Sign in' do
    visit '/users/sign_in'

    fill_in "user[email]",                 with: "user@example.com"
    fill_in "user[password]",              with: "password"
    click_button 'Sign in'

    page.find(  'i.icon-leaf.green' ).click

    fill_in "project[name]",                 with: "test name"
    fill_in "project[desc]",                 with: "test desc"

    click_button 'Save'
  end

  it 'should show error message' do
    click_button 'Create Task'
    page.should have_css '.alert-error'
  end

  it 'should be success' do
    fill_in 'task[title]',                     with:'task title'
    expect do
      click_button 'Create Task'
    end.to change(Task, :count).by(1)
  end

  it 'should be error message when create Sprint with title empty' do
    click_button 'Create'
    page.should have_css '.alert-error'
  end

  it 'should be success' do
    fill_in 'sprint[title]',                     with:'sprint title'
    expect do
      click_button 'Create'
    end.to change(Sprint, :count).by(1)
  end
end