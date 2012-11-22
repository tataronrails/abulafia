class Project < ActiveRecord::Base


  acts_as_commentable
  attr_accessible :desc, :name

  default_scope order('created_at DESC')

  has_many :discussions

end
