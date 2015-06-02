class TracksController < ApplicationController
  before_action :require_login, except: [:index]

  def index
    if params[:sort].present?
      @tracks = Track.unscoped.order(params[:sort]).all
    else
      @tracks = Track.all
    end
  end

  def new
    @track = Track.new
  end

  def create
    @track = Track.new(track_params)
    if @track.save
      redirect_to tracks_path, notice: "The #{@track.name} Track has been created."
    else
      flash.alert = "Please fix the errors below to continue."
      render :new
    end
  end

  private

  def track_params
    params.require(:track).permit(:name, :distance, :outdoor)
  end
end
