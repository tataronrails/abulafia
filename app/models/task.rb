class Task < ActiveRecord::Base
  attr_accessible :assigned_to, :end, :owner_id, :start, :status, :title, :estimate, :owner_id, :place

  belongs_to :project
  after_create :assign_discussion

  #default_scope order("updated_at DESC")

  #acts_as_commentable

  has_one :discussion, :as => :discussable



  validates :title, :presence => true, :length => { :minimum => 5 }


  include PublicActivity::Model
  tracked

  def status_via_words
    a = []
    a[0] = "estimate"
    a[1] = "start"
    a[2] = "finish"
    a[3] = "deliver"

    a[self.status]
  end


  def assigned_to_initials
    begin
      id = self.assigned_to
      User.where(:id => id).first.login[0..1]
    rescue
      ""
    end

  end

  private
  def assign_discussion
    self.create_discussion!(:title => self.title)
  end


end
