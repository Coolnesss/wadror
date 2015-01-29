module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    return 0 if ratings.empty?
    #todo if ratings.count == 0
    sum = 0
    ratingsToArray = self.ratings.to_a.map(&:score)
    ratingsToArray.each { |a| sum+=a }
    average = sum / self.ratings.size.to_f
    return average
  end

end
