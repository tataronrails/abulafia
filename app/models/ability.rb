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

    can :read, Strike
    can :create, Strike
    can :manage, Task
    can :manage, User


    can :destroy, Comment do |comment|
      comment.user == user
    end

    can :manage, Project do |project|
      project.admins.include?( user )
    end

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
