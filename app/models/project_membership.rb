class ProjectMembership < ActiveRecord::Base
  attr_accessible :role, :user, :project, :type_to_calculate , :rate

  extend Enumerize

  belongs_to :project
  belongs_to :user

  validates :user, :role, :presence => true

  enumerize :role, :in => [:member, :admin, :project_manager, :designer, :developer, :customer, :quality_assurance, :finance_manager]
end
