class Users::InvitationsController < Devise::InvitationsController
  def update

    #raise resource_params.to_json
    #
    #if this
    #  redirect_to root_path
    #else
    #  super
    #end


    first_name = params[:first_name]
    second_name = params[:second_name]
    initials = params[:initials]

    self.resource = resource_class.accept_invitation!(resource_params)

    resource.first_name = first_name
    resource.second_name = second_name

    #+Russian.translit(second_name)[0]


    if resource.errors.empty?
      set_flash_message :notice, :updated
      sign_in(resource_name, resource)

      respond_with resource, :location => after_accept_path_for(resource)
    else
      respond_with_navigational(resource) { render :edit }
    end


  end
end