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


  def destroy
    @strike = Strike.find(params[:id])
    @strike.destroy

    respond_to do |format|
      format.html {
        redirect_to :back, :notice => "Strike removed!"
      }
      format.html{
        redirect_to project_path(@project)
      }
    end
  end
end
