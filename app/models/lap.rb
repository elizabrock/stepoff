class Lap < ActiveRecord::Base
  belongs_to :user
  belongs_to :track

  validates_presence_of :user, :track
  validate :minimum_lap_time, if: [:user, :track]

  private

  def minimum_lap_time
    last_lap = user.laps.last
    earliest_valid_start_time = track.minimum_completion_time.seconds.ago
    if last_lap.present? && last_lap.created_at > earliest_valid_start_time
      errors[:base] << "is too soon"
    end
  end
end
