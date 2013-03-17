class Discussion < ActiveRecord::Base
  belongs_to :project
  #belongs_to :task
  has_many :users, :through => :comments, :uniq => true
  belongs_to :discussable, :polymorphic => true
  belongs_to :task, :foreign_key => :discussable_id, :conditions => "exists(select 1 from discussions d where d.discussable_type = 'Task' && d.discussable_id = tasks.id)"
  attr_accessible :title, :project_id, :desc

  ACTUAL_TIME = 3.day


  acts_as_commentable

  #include PublicActivity::Model
  #tracked owner: Proc.new { |controller, model| controller.current_user }

  default_scope order('created_at DESC')

  validates :title, :presence => true, :length => {:minimum => 5}

  def notificable_users(ignored_user)
    if self.discussable.is_a? Task
      project = self.discussable.project
    elsif self.discussable.is_a? Project
      project = self.discussable
    end

    if self.comments.count <= 1
      if project.present?
        project.users.where("users.id <> ?", ignored_user)
      else
        []
      end
    else
      self.users.joins(:comments).where("comments.created_at > ? AND comments.commentable_id = ? " +
                                            "AND comments.commentable_type = ? AND users.id <> ?",
                                        Time.now - ACTUAL_TIME, self, "Discussion", ignored_user)
    end
  end
end
