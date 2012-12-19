class CommentsController < ApplicationController
  load_and_authorize_resource :task

  respond_to :js

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      #format.html { redirect_to comments_url }
      #format.json { head :no_content }
      format.js {head :no_content }
    end
  end
end