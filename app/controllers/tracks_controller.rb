class TracksController < ApplicationController
  before_action :require_login, except: [:index]
  before_action :load_track, except: [:index]

  def index
    if params[:sort].present?
      @tracks = Track.unscoped.order(params[:sort]).all
    else
      @tracks = Track.all
    end
  end

  def create
    if @track.save
      redirect_to tracks_path, notice: "The #{@track.name} Track has been created."
    else
      flash.alert = "Please fix the errors below to continue."
      render :new
    end
  end

  def update
    if @track.save
      flash.notice = "#{@track.name} Track was updated successfully"
      redirect_to tracks_path
    else
      flash.alert = "Please fix the errors below to continue."
      render :edit
    end
  end

  def destroy
    @track.destroy
    redirect_to tracks_path, notice: "#{@track.name} Track has been deleted."
  end

  private

  def load_track
    if params[:id].present?
      @track = Track.find(params[:id])
    else
      @track = Track.new
    end
    if params[:track].present?
      @track.assign_attributes(track_params)
    end
  end

  def track_params
    params.require(:track).permit(:name, :distance, :outdoor)
  end
end
