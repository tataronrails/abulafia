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



  def update
    @strike = Strike.find(params[:id])

    respond_to do |format|
      if @strike.update_attributes(params[:strike])
        format.html { redirect_to strikes_path, notice: 'Strike was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { redirect_to strikes_path, notice: 'Strike was not updated.' }
        format.json { render json: @strike.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @strike = Strike.find(params[:id])
    @users = User.all
  end
end
