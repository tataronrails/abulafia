class Project < ActiveRecord::Base

  acts_as_commentable
  attr_accessible :desc, :name

  has_many :discussions

end
