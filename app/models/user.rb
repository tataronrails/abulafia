class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :invitable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :second_name, :cell, :im, :desc, :initials

  has_many :project_memberships
  has_many :projects, :through => :project_memberships


  def role_in_project project_id
    self.project_memberships.where(:project_id => project_id).first.role.text
  end

  def fio
    begin
      id(self.first_name && self.fist_name)
      id(self.first_name && self.second_name)
      id(self.first_name && self.second_name)
      id(self.first_name, self.second_name).join(" ")
    rescue
      "My"
    end




  end


end
