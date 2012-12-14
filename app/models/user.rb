class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :invitable


  validates_uniqueness_of :login


  before_create :create_login

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :second_name, :cell, :im, :desc, :initials, :hc_user_id, :login

  has_many :project_memberships
  has_many :projects, :through => :project_memberships


  def role_in_project project_id
    self.project_memberships.where(:project_id => project_id).first.role.text
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
