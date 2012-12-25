class Discussion < ActiveRecord::Base



  belongs_to :project
  #belongs_to :task

  belongs_to :discussable, :polymorphic => true
  attr_accessible :title, :project_id, :desc

  acts_as_commentable

  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }

  default_scope order('created_at DESC')



  validates :title, :presence => true, :length => { :minimum => 5 }
end
