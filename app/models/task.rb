class Task < ActiveRecord::Base
  acts_as_taggable
  attr_accessible :assigned_to, :end, :owner_id, :start, :status, :title, :estimate, :owner_id, :place, :tagging_list, :task_type, :behavior, :project_id

  belongs_to :project
  after_create :assign_discussion
  before_create :parse_text_to_add_tags_and_type

  has_one :discussion, :as => :discussable

  validates :title, :presence => true

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
    a[4] = "testing"
    a[5] = "reject"
    a[5] = "accept"

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
    a[6] = "story"

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



  def owner
    User.find(self.owner_id)
  end

  private

  def set_type_to_task object, source_text, string_to_find, type_to_set
    if source_text.include? string_to_find
      object.title = source_text.gsub(/^#{string_to_find}/, "").gsub(/^, /, "").gsub(/^ /, "")
      object.task_type = type_to_set
    end

  end

  def parse_text_to_add_tags_and_type
    text = self.title

    set_type_to_task self, text, "#bug", 1
    set_type_to_task self, text, "#feature", 0
    set_type_to_task self, text, "#chore", 2
    set_type_to_task self, text, "#story", 6


    #if text.include? "#bug"
    #  self.title = text.gsub(/^#bug/,"").gsub(/^, /,"").gsub(/^ /,"")
    #  self.task_type = 1
    #end
    ##
    #
    #if text.include? "#feature"
    #  self.title = text.gsub(/^#bug/,"").gsub(/^, /,"").gsub(/^ /,"")
    #  self.task_type = 1
    #end


  end




  def make_simple_task

    self.update_attributes(:task_type => "5") unless self.task_type.present?
  end

  def assign_discussion
    self.create_discussion!(:title => self.title)
    #
    make_simple_task
  end
end
