class Track < ActiveRecord::Base
  has_many :laps
  validates :name, presence: true,
                   length: {minimum: 3,
                            too_short: "name should have at least 3 characters"
                           },
                   uniqueness: true
  validates :distance, presence: true,
                       numericality: {
                         greater_than_or_equal_to: 0.1
                       }
  before_save :round_distance

  default_scope ->{ order(:name) }

  def minimum_completion_time
    return unless distance.present? && distance > 0
    distance * 450
  end

  protected

  def round_distance
    unless self.distance.nil?
      self.distance = self.distance.round(2)
    end
  end
end
