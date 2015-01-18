class Beer < ActiveRecord::Base
	belongs_to :brewery
	has_many :ratings

  def average_rating
    sum = 0
    ratingsToArray = ratings.to_a.map(&:score)
    ratingsToArray.each { |a| sum+=a }
    average = sum / ratings.size.to_f
    average
  end

  def to_s
    self.name + ", panimo: " + brewery.name
  end
end
