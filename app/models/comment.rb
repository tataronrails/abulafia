class Comment < ActiveRecord::Base

  include ActsAsCommentable::Comment


  attr_accessible :comment, :user_id

  belongs_to :commentable, :polymorphic => true

  after_create :notify


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
      users_to_notify = []
      users_notify_discuss.each do |user_in_project|
        unless user_in_project.is_online?
          users_to_notify.push  user_in_project

        end
      end
      jb = JabberBot.new(:user => users_to_notify)
      jb.message_for_comment(self)
      jb.send_message
    end
  end
  handle_asynchronously :notify

end
