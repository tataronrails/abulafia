class StrikesController < ApplicationController
  load_and_authorize_resource

  def index
    @strikes = Strike.order("created_at DESC")
  end

  def create
    strike = Strike.new(params[:strike])

    respond_to do |format|
      if strike.save
        format.html { redirect_to :back, notice: 'Skrike was successfully created.' }
      else
        format.html { redirect_to :back, notice: 'Skrike was not created.' }
      end
    end
  end
end
