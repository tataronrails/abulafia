class ProjectMembership < ActiveRecord::Base
  extend Enumerize

  belongs_to :project
  belongs_to :user

  attr_accessible :role, :user, :project

  validates_presence_of :project, :user, :role

  enumerize :role, :in => [:member, :admin, :project_manager, :designer, :developer, :customer, :quality_assurance, :finance_manager, :elance_developer, :elance_manager]
end
