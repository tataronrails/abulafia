class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :invitable


  validates_uniqueness_of :login


  #before_create :create_login

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :second_name, :cell, :im, :desc, :initials, :hc_user_id, :login

  has_many :project_memberships
  has_many :projects, :through => :project_memberships
  has_many :comments
  has_many :strikes


  ACTIVITY_INTERVAL=10.minutes


  def role_in_project project_id
    self.project_memberships.where(:project_id => project_id).first.role.text
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
    last_activity.present? && (Time.now - last_activity.created_at) <  ACTIVITY_INTERVAL
  end


  private
  def create_login
    self.login = email.split("@").first
  end





  #
  #
  #def initials
  #    self.email.split("@").first[0..2]
  #end


end
