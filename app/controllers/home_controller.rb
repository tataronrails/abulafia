class HomeController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:index]
  skip_authorization_check

  def index
  end

  def attachments
    @attachment = Attachment.new(params[:attachment])
    if @attachment.save
      html = %%<input type="hidden" name="comment[attachments_attributes][#{(rand * 10000).to_i}][id]" value="#{@attachment.id}">%
      render :text => html, :layout => false, :content_type => :html
    else
      render :text => @attachment.errors.full_messages.join(', '), :layout => false, :content_type => :html
    end
  end
end
