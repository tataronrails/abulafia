class Todo < ActiveRecord::Base
  attr_accessible :title, :checked

  belongs_to :task

  validates :title, :presence => true
end
