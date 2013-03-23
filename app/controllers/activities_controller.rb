class ActivitiesController < ItemsController
  defaults :resource_class => PublicActivity::Activity

  load_and_authorize_resource :class => PublicActivity::Activity

  actions :index

  private

  def collection
    # TODO refactor
    @activities = PublicActivity::Activity.where(:recipient_id => [current_user.projects.map(&:id)])
                                          .order('created_at DESC')
                                          .includes(:trackable)
                                          .page(params[:page]).per(50)
  end
end