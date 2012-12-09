class Users::InvitationsController < Devise::InvitationsController
  def update

    first_name = params[:first_name]
    second_name = params[:second_name]
    initials = params[:initials]

    self.resource = resource_class.accept_invitation!(resource_params)

    #self.resource.first_name = first_name
    #self.resource.second_name = second_name
    #self.resource.initials = initials



    if resource.errors.empty?
      set_flash_message :notice, :updated
      sign_in(resource_name, resource)
      resource.update_attributes(:first_name => "1 dsfdsfsdfds")


      respond_with resource, :location => after_accept_path_for(resource)
    else
      resource.update_attributes(:first_name => "2 dsfdsfsdfds")

      respond_with_navigational(resource) { render :edit }
    end


  end
end