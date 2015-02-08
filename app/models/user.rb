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

  def belongs_to_club? beer_club
    list = BeerClub.all.select{ |x| not x.users.find_by username:self.username}
    not list.include? beer_club
  end


  def favourite_brewery
    lista = beers.all.map(&:brewery)
    lista.max_by{|x| get_average_for_brewery x}
  end

  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favourite_style
    return nil if (ratings.empty?)
    lista = beers.all.map(&:style)
    lista.max_by{|x| get_average_for_style x}
  end

  def get_average_for_brewery brewery
    return nil if (ratings.empty?)
    ratings_for_brewery = ratings.select{|x| x.beer.brewery == brewery}
    ratings_for_brewery.map(&:score).inject{ |sum, el| sum + el }.to_f / ratings_for_brewery.size
  end

  def get_average_for_style style
    return nil if (ratings.empty?)
    ratings_for_style = ratings.select{|x| x.beer.style == style}
    ratings_for_style.map(&:score).inject{ |sum, el| sum + el }.to_f / ratings_for_style.size
  end
end
