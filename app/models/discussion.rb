class Discussion < ActiveRecord::Base


  belongs_to :project
  attr_accessible :title, :project_id

  acts_as_commentable


  validates :title, :presence => true, :length => { :minimum => 5 }
end
