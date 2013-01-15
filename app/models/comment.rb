class Comment < ActiveRecord::Base
  acts_as_paranoid
  include ActsAsCommentable::Comment


  attr_accessible :comment, :user_id

  belongs_to :commentable, :polymorphic => true

  after_create :notify


  default_scope :order => 'created_at DESC'

  validates_length_of :comment, :minimum => 2

  include PublicActivity::Model
  tracked(owner: Proc.new {|controller, model| controller.current_user }, recipient: Proc.new {|controller, model|  if model.kind_of?(Task); model.commentable.discussable.project; end; })

  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  #acts_as_voteable

  # NOTE: Comments belong to a user
  belongs_to :user


  def notify
    Rails.logger.debug "*** notify -> Comment.rb ***"
    if self.commentable.is_a? Discussion
      users_notify_discuss = self.commentable.notificable_users(self.user)
      users_to_notify = []


      users_notify_discuss.each do |user_in_project|
        #unless user_in_project.is_online?
        users_to_notify.push user_in_project
        #end
      end


      #raise users_to_notify.to_json

      #if Rails.env.eql? "development"
      #  users_to_notify = [User.first]
      #end


      #Rails.logger.info "--- users to notify---"
      #Rails.logger.info users_to_notify.to_json

      #Rails.logger.info "--- jabber bot init ---"
      #Rails.logger.debug jb = JabberBot.new(:user => users_to_notify)
      #Rails.logger.debug jb.message_for_comment(self)
      #Rails.logger.debug jb.send_message
      #Rails.logger.debug jb.send_message

      #send note to project room
      client = HipChat::Client.new("94ecc0337c81806c0d784ab0352ee7")
      begin
        client[self.commentable.discussable.project.name].send('bot', "+ comment: \"#{self.comment}\" in discussion #{self.title} by user #{self.user.login}", :color => 'yellow', :notify => true)
      rescue
        client['abulafia'].send('bot', "Can not find hipchat room for ptoject \"#{self.commentable.discussable.project.name}\"", color: 'red', notify: true)
      end

    end
  end

end
