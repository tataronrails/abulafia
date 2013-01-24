class SprintsController < ApplicationController
  def new
    @sprint = Sprint.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @sprint }
    end
  end
end
