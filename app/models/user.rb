class User < ActiveRecord::Base
  include RatingAverage

  has_secure_password

  validates :username,
                    uniqueness: true,
                    length: { in: 5..20 }
  validates :password,  length: { minimum: 4 }
  validates_format_of :password, :with => /(?=.*\d)(?=.*([A-Z]))/

  has_many :ratings
  has_many :beers, through: :ratings
  has_many :memberships
  has_many :beer_clubs, through: :memberships

  def self.most_ratings limit
    User.all.sort_by{|u| -(u.ratings.count||0) }.take(limit)
  end


  def belongs_to_club? beer_club
    list = BeerClub.all.select{ |x| not x.users.find_by username:self.username}
    not list.include? beer_club
  end

  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end

  def rating_of(category, item)
    ratings_of_item = ratings.select do |r|
      r.beer.send(category) == item
    end
    ratings_of_item.map(&:score).sum / ratings_of_item.count
  end

  def favorite(category)
    return nil if ratings.empty?

    category_ratings = rated(category).inject([]) do |set, item|
      set << {
        item: item,
        rating: rating_of(category, item) }
      end

      category_ratings.sort_by { |item| item[:rating] }.last[:item]
    end

    def rated(category)
      ratings.map{ |r| r.beer.send(category) }.uniq
    end

    def rating_of(category, item)
      ratings_of_item = ratings.select do |r|
        r.beer.send(category) == item
      end
      ratings_of_item.map(&:score).sum / ratings_of_item.count
    end

  def favorite_brewery
    favorite :brewery
  end

  def favorite_style
    favorite :style
  end
end
