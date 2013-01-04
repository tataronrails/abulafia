class Strike < ActiveRecord::Base
  belongs_to :user
  attr_accessible :assigned_by, :desc, :task_id, :user_id, :date_of_assignment

  has_one :discussion, :as => :discussable
  after_create :assign_discussion



  private
  def assign_discussion
    self.create_discussion!(:title => self.desc[0,10])
  end
end
