class Discussion < ActiveRecord::Base
  belongs_to :project
  attr_accessible :title, :project_id

  validates :title, :presence => true, :length => { :minimum => 5 }
end
