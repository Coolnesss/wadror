module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    sum = 0
    ratingsToArray = self.ratings.to_a.map(&:score)
    ratingsToArray.each { |a| sum+=a }
    average = sum / self.ratings.size.to_f
    average
  end

end