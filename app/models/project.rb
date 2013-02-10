class Project < ActiveRecord::Base
  include PublicActivity::Model
  attr_accessible :desc, :name, :is_department
  has_many :discussions, :dependent => :destroy
  has_many :tasks, :dependent => :destroy
  has_many :project_memberships, :dependent => :destroy
  has_many :sprints, :dependent => :destroy
  has_many :users, :through => :project_memberships

  has_one :column_order, :dependent => :destroy

  validates :name, :presence => true, :length => {:minimum => 3}

  default_scope order(" created_at DESC")
  scope :without_departments, where(:is_department => false)
  scope :only_departments, where(:is_department => true)


  acts_as_paranoid
  acts_as_commentable

  #tracked owner: Proc.new{ |controller, model| controller.current_user }
  tracked(owner: Proc.new {|controller, model| controller.current_user }, recipient: Proc.new {|controller, model| model })

  after_create :create_column_order

  def create_column_order
    self.column_order.create_column_order!
  end

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

  def urgent
    self.tasks.where(:task_type => "3").order("end")
  end

  def draft
    self.tasks.where(:task_type => "5").order("finished_at").order("created_at DESC")
  end

  def current_tasks
    self.tasks.with_place(:current)
  end
  #
  #def my_work user
  #  self.tasks.where(:assigned_to => user.id).where("task_type != 5").where("task_type != 3")
  #end

  def icebox_tasks
    self.tasks.with_place(:icebox)
  end

  def backlog_tasks(reorder = false)
    tasks = self.tasks.with_place(:backlog)
    if reorder
      temp = []
      self.column_order.positions.each do |position|
        temp << tasks.select { |task| task.id == position.to_i }
      end
      tasks = temp
    end
    tasks.flatten
  end

end
