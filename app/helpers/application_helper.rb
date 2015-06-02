module ApplicationHelper
  def location_of(track)
    track.outdoor? ? "outdoors" : "indoors"
  end
end
