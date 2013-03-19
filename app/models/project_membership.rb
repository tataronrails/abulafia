class ProjectMembership < ActiveRecord::Base
  extend Enumerize

  belongs_to :project
  belongs_to :user

  attr_accessible :role, :user, :project

  validates :project, :user, :role, :presence => true

  enumerize :role, :in => [:member, :admin, :project_manager, :designer, :developer, :customer, :quality_assurance, :finance_manager, :elance_developer, :elance_manager]
end
