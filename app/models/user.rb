class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :second_name, :cell, :im, :desc,
                  :initials, :hc_user_id, :login

  devise :invitable, :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  has_one :discussion, :as => :discussable
  has_one :account, :as => :owner, :dependent => :destroy

  has_many :project_memberships
  has_many :projects, :through => :project_memberships
  has_many :comments
  has_many :strikes

  ACTIVITY_INTERVAL = 10.minutes

  with_options :if => :is_virtual_user? do |user|
    user.validates :login, :uniqueness => true
    user.validates :login, :email, :im, :first_name, :second_name, :initials, :presence => true
  end

  after_create :assign_discussion_to_user

  def tasks
    Task.where('tasks.assigned_user_id = :user_id OR tasks.owner_id = :user_id', :user_id => self.id)
  end

  def to_s
    fio
  end

  #TODO: refactor
  def role_in_project project_id
    begin
      self.project_memberships.where(:project_id => project_id).first.role.text
    rescue NoMethodError
      'error'
    end

  end

  def role project_id
    self.project_memberships.where(:project_id => project_id).first.role
  end


  def fio
    if self.first_name.present? && self.second_name.present?
      [self.first_name, self.second_name].join(" ")
    else
      self.login
    end

  end

  def is_online?
    last_activity = PublicActivity::Activity.where(owner_id: self).order('created_at desc').first
    last_activity.present? && (Time.now - last_activity.created_at) < ACTIVITY_INTERVAL
  end

  def my_tasks
    Task.where(:assigned_to => self.id).order(:created_at).delete_if { |t| (t.status == 2) || (t.finished_at.present?) || (t.hours_worked_on_task.present?) }
  end

  private

  def create_login
    self.login = email.split("@").first
  end


  def assign_discussion_to_user
    self.create_discussion!(:title => "self.login")
  end

  def is_virtual_user?
    self.invitation_sent_at.nil?
  end
end
