class Project < ActiveRecord::Base
  include PublicActivity::Model
  attr_accessible :desc, :name, :is_department
  has_many :discussions, :dependent => :destroy
  has_many :tasks, :dependent => :destroy
  has_many :project_memberships, :dependent => :destroy
  has_many :sprints, :dependent => :destroy
  has_many :users, :through => :project_memberships

  validates :name, :presence => true, :length => {:minimum => 3}

  default_scope order(" created_at DESC")
  scope :without_departments, where(:is_department => false)
  scope :only_departments, where(:is_department => true)


  acts_as_paranoid
  acts_as_commentable

  #tracked owner: Proc.new{ |controller, model| controller.current_user }
  tracked(owner: Proc.new {|controller, model| controller.current_user }, recipient: Proc.new {|controller, model| model })



  # define project.admins, project.members ... methods
  ProjectMembership.role.values.each do |r|
    send(:define_method, r.underscore.pluralize) do
      self.project_memberships.where(:role => r.underscore).map(&:user)
    end
  end


  def project_manager
    #self.project_memberships.where(:project_id => project_id).first.role.text
    pm = nil
    project = self
    self.users.each do |u|
      if u.project_memberships.where(:project_id => project.id).first.role == "project_manager"
        pm = u
      end
    end
    pm
  end

  def current_sprint
    sprints.currents.first
  end

  # status_via_words
  #a[0] = "estimate"
  #a[1] = "start"
  #a[2] = "finish"
  #a[3] = "pushed"
  #a[4] = "testing"
  #a[5] = "accept/reject"

  #type_via_words
  #a = []
  #a[0] = "feature"
  #a[1] = "bug"
  #a[2] = "chore"
  #a[3] = "instruction"
  #a[4] = "self_task"
  #a[5] = "easy_task"
  #a[6] = "story"

  # moved to Task scope
  #
  def urgent
     tasks.without_sprint.urgent
  end

  def draft
     tasks.without_sprint.draft
  end

  def current_work
    tasks.without_sprint.current_work
  end

  def my_work user
     tasks.without_sprint.my_work user
  end

  def icebox
     tasks.without_sprint.icebox
  end

  def backlog
     tasks.without_sprint.backlog
  end

end
