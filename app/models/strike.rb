class Strike < ActiveRecord::Base
  belongs_to :user
  attr_accessible :assigned_by, :desc

  has_one :discussion, :as => :discussable
  after_create :assign_discussion



  private
  def assign_discussion
    self.create_discussion!(:title => self.title)
  end
end
