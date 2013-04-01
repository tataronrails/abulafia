class Projects::TransactionsController < ItemsController
  load_and_authorize_resource

  belongs_to :project, :optional => true

  def create
    resource.author = current_user
    create!
  end
end
