class Project < ActiveRecord::Base
  include PublicActivity::Model
  attr_accessible :desc, :name, :is_department
  has_many :discussions, :dependent => :destroy
  has_many :tasks, :dependent => :destroy
  has_many :project_memberships, :dependent => :destroy
  has_many :sprints, :dependent => :destroy
  has_many :users, :through => :project_memberships

  has_many :task_discussions, :through => :tasks, :source => :discussion
  has_many :task_comments, :through => :task_discussions, :source => :comments

  validates :name, :presence => true, :length => {:minimum => 3}

  default_scope order(" created_at DESC")
  scope :without_departments, where(:is_department => false)
  scope :only_departments, where(:is_department => true)

  acts_as_paranoid
  acts_as_commentable

  acts_as_accountable

  #tracked owner: Proc.new{ |controller, model| controller.current_user }
  tracked(owner: Proc.new { |controller, model| controller.current_user }, recipient: Proc.new { |controller, model| model })


  # define project.admins, project.members ... associations
  ProjectMembership.role.values.each do |r|
    relation_name = r.underscore.pluralize.to_sym
    has_many relation_name, :through => :project_memberships, :source => :user, :conditions => "project_memberships.role = '#{r}'"
  end

  def to_s
    name
  end

  def project_manager
    project_managers.to_a.first
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
