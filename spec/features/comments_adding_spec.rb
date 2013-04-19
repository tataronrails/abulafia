require 'spec_helper'

describe "Create message" do
  let(:project){ Project.create(:name => 'test project') }


  before 'Sign in' do
    visit '/users/sign_in'

    fill_in "user[email]",                 with: "user@example.com"
    fill_in "user[password]",              with: "password"
    click_button 'Sign in'

    current_user = User.create(:email => 'bash@example.com', :im => 'test', :login => 'bash',:password => 'password',
                                :password_confirmation => 'password', :initials => 'v.v',:first_name => 'Vic', :second_name => 'Pas')

    @task = project.tasks.create(:title => 'title')
    visit project_task_path(project, @task)
  end

  it 'It should be error if message empty' do
    #fill_in "task_comment",              with: ""
    #
    #click_button 'Say it using Markdown'
    #page.should have_css '#error_explanation'



  end

  it 'It should be success' do
    fill_in "task_comment",              with: "To long sentiments"

    click_button 'Say it using Markdown'
    page.should have_css '#comments_line'
  end
end