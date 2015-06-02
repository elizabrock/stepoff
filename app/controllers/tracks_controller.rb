class TracksController < ApplicationController
  def index
    if params[:sort].present?
      @tracks = Track.unscoped.order(params[:sort]).all
    else
      @tracks = Track.all
    end
  end
end
