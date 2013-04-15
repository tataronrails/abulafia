class Project < ActiveRecord::Base
  include PublicActivity::Model
  attr_accessible :desc, :name, :is_department
  has_many :discussions, :dependent => :destroy
  has_many :tasks, :dependent => :destroy
  has_many :project_memberships, :dependent => :destroy
  has_many :sprints, :dependent => :destroy
  has_many :users, :through => :project_memberships

  has_many :task_discussions, :through => :tasks, :source => :discussion
  has_many :task_comments, :through => :task_discussions, :source => :comments

  validates :name, :presence => true, :length => {:minimum => 3}

  default_scope order(" created_at DESC")
  scope :without_departments, where(:is_department => false)
  scope :only_departments, where(:is_department => true)

  acts_as_paranoid
  acts_as_commentable

  acts_as_accountable

  #tracked owner: Proc.new{ |controller, model| controller.current_user }
  tracked(owner: Proc.new { |controller, model| controller.current_user }, recipient: Proc.new { |controller, model| model })


  # define project.admins, project.members ... associations
  ProjectMembership.role.values.each do |r|
    relation_name = r.underscore.pluralize.to_sym
    has_many relation_name, :through => :project_memberships, :source => :user, :conditions => "project_memberships.role = '#{r}'"
  end

  def to_s
    name
  end

  def project_manager
    project_managers.to_a.first
  end

  def current_sprint
    sprints.currents.first
  end
  
  
  def self.current_progress (user)              #TO DO - augment tracking for variuos specific events
    raw_activities = PublicActivity::Activity            
      .where(:recipient_id => [user.projects.map(&:id)])
      .where("created_at > ?", 4.days.ago)
      .includes(:trackable)
      .group_by{|rec| rec.created_at.beginning_of_day}                             # group by date
      .sort_by{|k,v| k.to_i}
      .reverse                   
    
    activities = []  
    # nested grouping
    raw_activities.each do |elem|
      k1,v1 = elem
      second_layer_elem = v1.group_by(&:trackable_type)    # group by type of activity
                            .symbolize_keys!  
      puts second_layer_elem.keys                               
      new_second_layer = []
      second_layer_elem.each do |k2,v2|
        third_layer_elem = v2.group_by do |s|                              # group by definite entity
                               if s.trackable.kind_of? Project
                                 s.trackable.name.to_sym 
                               elsif s.trackable.kind_of? Task
                                 s.trackable.title.to_sym
                               elsif  s.trackable.kind_of? Comment
                                 s.trackable.task.title.to_sym
                               end
                           end                                                              
                           .sort_by{|ks,vs| vs.sort_by{|arr_el| arr_el.created_at.to_i}.max}  # what entity has the most recent update
                           .reverse                                             
        
        new_third_layer = []
        third_layer_elem.each do|e|  
          k3,v3 = e                                                             # sort by most recent updates among this entity's activities
          new_third_layer << [k3, v3.sort_by{|el| el.trackable.created_at.to_i}.reverse ]   # entity_name -> [activity]
        end
        new_second_layer << [k2, new_third_layer]                                   # activity_type -> [entity_name]
      end                                             
      activities << [k1,new_second_layer]                                          # tracked_day -> [activity_type]
    end
    activities
  end

  # status_via_words
  #a[0] = "estimate"
  #a[1] = "start"
  #a[2] = "finish"
  #a[3] = "pushed"
  #a[4] = "testing"
  #a[5] = "accept/reject"

  #type_via_words
  #a = []
  #a[0] = "feature"
  #a[1] = "bug"
  #a[2] = "chore"
  #a[3] = "instruction"
  #a[4] = "self_task"
  #a[5] = "easy_task"
  #a[6] = "story"

  # moved to Task scope
  #
  # def urgent
  #   self.tasks.where(:task_type => "3").order("end")
  # end
  #
  # def draft
  #   self.tasks.where(:task_type => "5").order("finished_at").order("created_at DESC")
  # end
  #
  # def current_work
  #  self.tasks.where("task_type != 5").where("status != 0").where("place != 1").order("status DESC")
  # end
  #
  # def my_work user
  #   self.tasks.where(:assigned_to => user.id).where("task_type != 5").where("task_type != 3")
  # end

  # def icebox
  #   self.tasks.where(:place => 0).where("task_type IN (0,1,2,6)")
  #   #.where("task_type != 5").where("task_type != 3")
  # end
  #
  # def backlog
  #   self.tasks.where("task_type NOT IN (5,3,4,6)").where(:place => 1)
  # end

end
