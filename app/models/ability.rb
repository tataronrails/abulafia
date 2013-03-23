class Ability
  include CanCan::Ability

  def initialize(user)
    cannot :manage, :all
    user ||= User.new

    can :read, Project do |project|
      project.users.include?( user )
    end

    can [:add_new_comment, :read], Discussion do |discussion|
      discussion.project.users.include?( user )
    end

    can :create, Discussion do |discussion|
      discussion.project.members.include?( user ) ||
          discussion.project.admins.include?( user )
    end

    can :create, Project
    can :create, Comment
    can :manage, Transaction
    can :manage, PublicActivity::Activity

    # better use heimdallr if we'll have many field based restrictions
    # https://github.com/roundlake/heimdallr
    # habrahabr: http://habrahabr.ru/company/roundlake/blog/141282/
    can :manage_sprints, Task do |task|
      task.project.admins.include?( user ) ||
        task.project.project_managers.include?( user )
    end

    can :manage, Strike
    can :manage, Sprint
    can [:create, :update, :read, :add_new_comment, :my], Task
    can :manage, User

    can :my, Task

    can :destroy, Comment do |comment|
      comment.user == user
    end

    can :manage, Project do |project|
      project.admins.include?( user )
    end
  end
end
