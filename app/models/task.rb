class Task < ActiveRecord::Base
  acts_as_taggable
  acts_as_paranoid
  attr_accessible :assigned_to, :end, :owner_id, :start, :status,
                  :title, :estimate, :owner_id, :place, :tagging_list,
                  :task_type, :behavior, :project_id, :desc, :sprint_id

  belongs_to :project
  belongs_to :sprint

  after_create :assign_discussion
  before_create :parse_text_to_add_tags_and_type
  after_update :notify_assigned_user, :if => Proc.new { |task| task.assigned_to.present? }

  has_one :discussion, :as => :discussable

  validates :title, :presence => true

  include PublicActivity::Model
  tracked(owner: Proc.new { |controller, model| controller.current_user }, recipient: Proc.new { |controller, model| model.project })

  scope :not_finished, where("`tasks`.`end` > '#{Time.now}'")
  scope :urgent, where(:task_type => "3").order("end")
  scope :draft, where(:task_type => "5").order("finished_at").order("created_at DESC")
  scope :current_work, where("task_type != 5").where("status != 0").where("place != 1").order("status DESC")
  scope :icebox, where(:place => 0).where("task_type IN (0,1,2,6)")
  scope :backlog, where("task_type NOT IN (5,3,4,6)").where(:place => 1)
  scope :my_work, lambda { |user| where(:assigned_to => user.id).where("task_type != 5").where("task_type != 3")}
  scope :without_sprint, where( sprint_id: nil)

  #acts_as_taggable_on :skills

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
    #a[5] = "accept"

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

      #gravatar_image_tag

      #send note to project room
      #client = HipChat::Client.new("94ecc0337c81806c0d784ab0352ee7")
      #begin
      #  client[self.project.name].send('bot', "Task \"#{self.title}\" assigned to user <b>#{ass_user.login}</b> #{gravatar_image_tag(ass_user.login)}", :color => 'yellow', :notify => true)
      #rescue
      #  client['abulafia'].send('bot', "No room #{self.project.name}", color: 'red', notify: true)
      #end


      #begin
      #Rails.logger.info jb.send_message
      #rescue Exception
      #  Rails.logger.error "notify_assigned_user problem: #{Exception.to_json}"
      #end
    end
  end

end
