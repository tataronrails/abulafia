class Task < ActiveRecord::Base
  attr_accessible :assigned_to, :end, :owner_id, :start, :status, :title, :estimate, :place, :tagging_list,
                  :task_type, :behavior, :project_id, :desc, :sprint_id, :status_behavior, :assigned_user_id

  belongs_to :project
  belongs_to :sprint
  belongs_to :assigned_user, :class_name => User

  after_initialize :set_status_behavior
  after_create :assign_discussion
  before_create :parse_text_to_add_tags_and_type
  #after_update :notify_assigned_user, :if => Proc.new { |task| task.assigned_to.present? }

  has_one :discussion, :as => :discussable

  validates :title, :presence => true

  include PublicActivity::Model
  #tracked(owner: Proc.new { |controller, model| controller.current_user }, recipient: Proc.new { |controller, model| model.project })

  acts_as_taggable
  acts_as_paranoid

  scope :not_finished, where("`tasks`.`end` > '#{Time.now}'")
  scope :urgent, where(:task_type => "3").order("end")
  scope :draft, where(:task_type => "5").order("finished_at").order("created_at DESC")
  scope :current_work, where("task_type != 5").where("status != 0").where("place != 1").order("status DESC")
  scope :icebox, where(:place => 0).where("task_type IN (0,1,2,6)")
  scope :backlog, where("task_type NOT IN (5,3,4,6)").where(:place => 1)
  scope :my_work, lambda { |user| where(:assigned_to => user.id).where("task_type != 5").where("task_type != 3")}
  scope :without_sprint, where( sprint_id: nil)

  def set_status_behavior
    @status_behavior = case self.task_type
      when '0' then FeatureBehavior.new(self)
      when '1' then BugBehavior.new(self)
      when '2' then ChoreBehavior.new(self)
      when '5' then EasyBehavior.new(self)
      else EasyBehavior.new(self)
    end
  end

  def status_behavior
    @status_behavior
  end

  def status_behavior=(value)
    @status_behavior.fire_state_event(value.to_sym)
  end

  def status_events
    @status_behavior.state_events.collect do |event|
      { event: event, event_text: I18n.t("state_machine.task.event.#{event}") }
    end
  end

  def tagging_list=(tags_list)
    self.tag_list = tags_list
  end

  def tagging_list
    tag_list
  end

  #def not_finished
  #
  #end

  def status_via_words
    a = []
    a[0] = "estimate"
    a[1] = "start"
    a[2] = "finish"
    a[3] = "pushed"
    a[4] = "testing"
    a[5] = "accept/reject"

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

      if User.find(id).initials.present?
        User.find(id).initials
      else
        User.find(id).login
      end

    rescue
      ""
    end
  end


  def owner
    User.find(self.owner_id)
  end

  def assigned_to_user
    begin
      User.find(self.assigned_to)
    rescue ActiveRecord::RecordNotFound
      Rails.logger.error "Error assigned user!"
    end

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
  end


  def make_simple_task
    self.update_attributes(:task_type => "5") unless self.task_type.present?
  end

  def assign_discussion
    self.create_discussion!(:title => self.title)
    #
    make_simple_task
  end

  def notify_assigned_user
    Rails.logger.debug "*** notify_assigned_user -> Task.rb ***"
    unless self.assigned_to_was == self.assigned_to
      assigned_user = []
      ass_user = User.find(self.assigned_to)
      assigned_user.push ass_user
      jb = JabberBot.new(:user => assigned_user)
      jb.message_for_task(self)
      jb.room_message_for_task(self)
      #jb.room_message.concat " #{gravatar_image_tag(ass_user.email).html_safe? }"
      jb.room_for_task(self)
      jb.sms_for_task(self)
      Rails.logger.info jb.send_message
    end
  end

end
