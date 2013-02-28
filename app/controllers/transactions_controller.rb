class TransactionsController < InheritedResources::Base
  load_and_authorize_resource

  #def create
  #  resource.author = current_user
  #  create!
  #end
end
