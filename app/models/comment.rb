class Comment < ActiveRecord::Base

  include ActsAsCommentable::Comment
  #include Rails.application.routes.url_helpers

  attr_accessible :comment, :user_id

  belongs_to :commentable, :polymorphic => true

  after_create :notify
  #ACTUAL_TIME = 3.day

  default_scope :order => 'created_at DESC'

  validates_length_of :comment, :minimum => 2

  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }

  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  #acts_as_voteable

  # NOTE: Comments belong to a user
  belongs_to :user


  def notify
    if self.commentable.is_a? Discussion
      users_notify_discuss = self.commentable.notificable_users(self.user)
      users_notify_discuss.each do |user_in_project|
        unless user_in_project.is_online?
          #jb = JabberBot.new(:user => user_in_project, :message => "new comment in discuss  \"#{self.commentable.title}\" in project \"#{self.commentable.discussable.project.name}\" http://abulafia.ru/tasks/#{self.commentable.discussable.id}")
          #jb.send_message
          jb = JabberBot.new(:user => user_in_project)
          jb.message_for_comment(self)
          jb.send_message
        end
      end
    end
  end
  handle_asynchronously :notify

end
