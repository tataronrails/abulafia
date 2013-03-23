class UsersController < ItemsController
  load_and_authorize_resource

  actions :show
end