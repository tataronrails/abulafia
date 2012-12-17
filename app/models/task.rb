class Task < ActiveRecord::Base
  acts_as_taggable
  attr_accessible :assigned_to, :end, :owner_id, :start, :status, :title, :estimate, :owner_id, :place, :tagging_list, :task_type, :behavior

  belongs_to :project
  after_create :assign_discussion

  has_one :discussion, :as => :discussable

  validates :title, :presence => true, :length => {:minimum => 5}


  include PublicActivity::Model
  tracked


  #acts_as_taggable_on :skills

  def tagging_list=(tags_list)
    self.tag_list = tags_list
  end

  def tagging_list
    tag_list
  end

  def status_via_words
    a = []
    a[0] = "estimate"
    a[1] = "start"
    a[2] = "finish"
    a[3] = "deliver"
    a[4] = "reject"

    a[self.status]
  end

  def type_via_words
    a = []
    a[0] = "feature"
    a[1] = "bug"
    a[2] = "chore"
    a[3] = "instruction"
    a[4] = "self_task"
    a[5] = "easy_task"

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
