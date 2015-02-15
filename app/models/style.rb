class Style < ActiveRecord::Base
  has_many :beers
  has_many :ratings, through: :beers

  def self.top(n)
    sorted_by_rating_in_desc_order = Style.all.sort_by{ |s| -(s.average_rating||0) }
    sorted_by_rating_in_desc_order.take(n)
  end

  def average_rating
    ratings.map{ |r| r.score }.sum / ratings.count.to_f
  end

end
