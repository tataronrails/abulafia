class Project < ActiveRecord::Base


  attr_accessible :desc, :name

  default_scope order('created_at DESC')

  has_many :discussions
  acts_as_commentable


end
