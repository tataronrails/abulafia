class ProjectMembership < ActiveRecord::Base
  extend Enumerize

  belongs_to :project
  belongs_to :user

  attr_accessible :role, :user, :project, :type_to_calculate , :rate

  validates_presence_of :project, :user, :role

  enumerize :role, :in => [:member, :admin, :project_manager, :designer, :developer, :customer, :quality_assurance, :finance_manager]
end
